#!/bin/bash
########
# Script to create swu-image file for system update
# is configured by files and command line options
# -s sets SWUIMAGE_CFG path to file containing:
#    DTB_NAME : the name of the device tree
#    SWU_INPUT_FILES: files to include in .swu image (rootfs, sw-update.sh...)
# $TARGET_DIR/etc/digitalrooster_build_info for revision 
# sw-description.in : a board specific template file (copied to $BINARIES_DIR)
# sw-update.sh      : optional board specific update script included in .swu
########

set -e

# iterate over command line arges and extract -s to set SWUIMAGE_CFG
. $(dirname $0)/post_image_opts.sh

[ -z "$SWUIMAGE_CFG"  ] && {
    echo "image configuration option -s is missing!"
    exit 1
}

# Version for swu-file name and sw-description
test -r $SWUIMAGE_CFG || {
    echo "cannot read swu image configuration"
    exit 1 
}
. $SWUIMAGE_CFG

# Figure out board name
BOARD=$(basename $BOARD_DIR)

#source build information REVISION and BUILD_DATE
test -r $TARGET_DIR/etc/digitalrooster_build_info && \
    . $TARGET_DIR/etc/digitalrooster_build_info

function set_hash ()
{
    file=$1
    symbol=$2
    local hash=$(sha256sum  $1  | cut -d' ' -f 1)
    sed -i -e "s%$symbol%${hash}%g" $BINARIES_DIR/sw-description
}

# content of sw-description and content is board specific.
# TODO: Check how to make this script work for all boards
SW_DESC_HEADER="sw-description "
cp "${BOARD_DIR}/sw-description.in" "$BINARIES_DIR/sw-description"
cp "${BOARD_DIR}/sw-update.sh" "$BINARIES_DIR/sw-update.sh"

sed -i -e "s%@VERSION@%$REVISION%g" $BINARIES_DIR/sw-description
# Update name of device tree in sw-description
sed -i -e "s%@DTB_NAME@%$DTB_NAME%g" $BINARIES_DIR/sw-description

gzip -9 -k -f $BINARIES_DIR/rootfs.ext2 

# update hashes in sw-description template
set_hash $BINARIES_DIR/zImage @KERNEL_HASH@
set_hash $BINARIES_DIR/$DTB_NAME @DTB_HASH@
set_hash $BINARIES_DIR/sw-update.sh @SW_UPDATE_SCRIPT_HASH@
set_hash $BINARIES_DIR/rootfs.ext2.gz @ROOTFS_IMAGE_HASH@

if [ ! -z "$SWU_IMAGE_SIG_KEY_PATH" ] && [ ! -z "$SWU_IMAGE_CERT_PATH" ] ;
then
    echo "> Signing image using key from $SWU_IMAGE_SIG_KEY_PATH"
    # Sign sw-description
    openssl dgst -sha256 -sign $SWU_IMAGE_SIG_KEY_PATH \
	     $BINARIES_DIR/sw-description >  $BINARIES_DIR/sw-description.sig

    # check if signatures can be verified with public cert installed on target
    openssl dgst -sha256 -verify $TARGET_DIR/etc/swupdate/sw-update-cert.pem\
	    -signature $BINARIES_DIR/sw-description.sig  \
	    $BINARIES_DIR/sw-description
    if [ $? -ne "0" ];
    then
	echo " Signature verification failed! "
	exit 1
    fi    
    SW_DESC_HEADER="$SW_DESC_HEADER sw-description.sig"
fi

# Work in BINARIES_DIR  Create cpio
echo "> Creating swu-image: $BOARD-$REVISION.swu"
cd $BINARIES_DIR
find $SW_DESC_HEADER $SWU_INPUT_FILES \
    | cpio -ov -H crc > $BOARD-$REVISION.swu


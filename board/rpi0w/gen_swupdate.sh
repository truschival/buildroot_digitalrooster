#!/bin/bash

set -e
BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename $BOARD_DIR)"

# Version for swu-file name and sw-description
. $BOARD_DIR/VERSION_INFO
SWU_INPUT_FILES="zImage digitalrooster-rpi0w.dtb sw-update.sh rootfs.ext2.gz"

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

sed -i -e "s%@VERSION@%$VERSION%g" $BINARIES_DIR/sw-description
gzip -9 -k -f $BINARIES_DIR/rootfs.ext2 

# update hashes in sw-description template
set_hash $BINARIES_DIR/zImage @KERNEL_HASH@
set_hash $BINARIES_DIR/digitalrooster-rpi0w.dtb @DTB_HASH@
set_hash $BINARIES_DIR/sw-update.sh @SW_UPDATE_SCRIPT_HASH@
set_hash $BINARIES_DIR/rootfs.ext2.gz @ROOTFS_IMAGE_HASH@

if [ ! -z "$SWU_IMAGE_SIG_KEY_PATH" ] && [ ! -z "$SWU_IMAGE_CERT_PATH" ] ;
then
    echo "> Signing image using key from $SWU_IMAGE_SIG_KEY_PATH"
    # Sign sw-description
    openssl dgst -sha256 -sign $SWU_IMAGE_SIG_KEY_PATH \
	     $BINARIES_DIR/sw-description >  $BINARIES_DIR/sw-description.sig

    # check if signatures can be verified with public cert
    openssl dgst -sha256 -verify $TARGET_DIR/etc/ssl/certs/sw-update-cert.pem\
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
cd $BINARIES_DIR
find $SW_DESC_HEADER $SWU_INPUT_FILES \
    | cpio -ov -H crc > sw-update-$VERSION.swu


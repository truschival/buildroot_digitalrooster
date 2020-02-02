#!/bin/bash

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"
GENIMAGE_CFG="${BOARD_DIR}/genimage.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
	--rootpath "${TARGET_DIR}"     \
	--tmppath "${GENIMAGE_TMP}"    \
	--inputpath "${BINARIES_DIR}"  \
	--outputpath "${BINARIES_DIR}" \
	--config "${GENIMAGE_CFG}"


rm -f ${BINARIES_DIR}/rootfs.ext2.gz
gzip -9 ${BINARIES_DIR}/rootfs.ext2
cp $BOARD_DIR/sw-description ${BINARIES_DIR}
cp $BOARD_DIR/sw-update.sh ${BINARIES_DIR}

FILES="sw-description \
		      zImage \
		      digitalrooster-bananapi-m2-zero.dtb\
		      boot.scr \
		      uEnv.txt \
		      rootfs.ext2.gz \
		      sw-update.sh"
cd $BINARIES_DIR
for i in $FILES;do
        echo $i;done | cpio -ov -H crc >  DigitalRooster@BananaPi.swu



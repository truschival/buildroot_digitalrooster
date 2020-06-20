#!/bin/bash

. $(dirname $0)/post_image_opts.sh

[ -z "$GENIMAGE_CFG"  ] && {
    echo "image configuration option -c is missing!"
    exit 1
}

GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"
rm -rf "${GENIMAGE_TMP}"

genimage                           \
    --loglevel 0                   \
    --rootpath "${TARGET_DIR}"     \
    --tmppath "${GENIMAGE_TMP}"    \
    --inputpath "${BINARIES_DIR}"  \
    --outputpath "${BINARIES_DIR}" \
    --config "${GENIMAGE_CFG}"

GENIMAGE_RET=$?

echo "-- common/post_image.sh returns $GENIMAGE_RET --"
exit $GENIMAGE_RET



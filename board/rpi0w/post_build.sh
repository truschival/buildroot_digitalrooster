#!/bin/bash

set -e

BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi




##
# Install custom config.txt & cmdline.txt
##
cp ${BOARD_DIR}/config.txt  ${BINARIES_DIR}/rpi-firmware/
cp ${BOARD_DIR}/cmdline.txt ${BINARIES_DIR}/rpi-firmware/


##
# Add custom Device tree overlays to imges/rpi-firmware/overlays
##
cp -r ${BR2_EXTERNAL_DigitalRooster_PATH}/board/rpi0w/dt-overlays/* \
   ${BINARIES_DIR}/rpi-firmware/overlays

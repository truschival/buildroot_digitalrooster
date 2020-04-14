#!/bin/sh

set -u
set -e
set -x
BOARD_DIR="$(dirname $0)"
BOARD_NAME="$(basename ${BOARD_DIR})"

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

##
# Install firmware files
##
cp -r ${BOARD_DIR}/firmware/* ${TARGET_DIR}/lib/firmware/

##
# Create a default uEnv.txt
##
cp -r ${BOARD_DIR}/uEnv.txt ${BINARIES_DIR}

#!/bin/sh

set -u
set -e
set -x

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi


##
# Install firmware files
##
cp -r ${BR2_EXTERNAL_DigitalRooster_PATH}/board/bananapi_m2_zero/firmware/* \
   ${TARGET_DIR}/lib/firmware/

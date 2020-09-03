#!/bin/sh

################################################################################
# Swupdate script called automatically with either
# "preinst" or "postinst" as arguments by update process
# Assumes following disk/flash layout:
# /dev/mmcblk0p1 boot partition (vfat) u-boot, kernel, devicetree, uEnv.txt
# /dev/mmcblk0p2 rootfs1 (ext) active or standby
# /dev/mmcblk0p3 rootfs2 (ext) active or standby
# /dev/mmcblk0p4 persistent data (application and user config)
# 
# standby partition will be updated by this script
# 
#
# !! Do not run if you don't understand what it does!!
################################################################################

set -e
test -e /etc/swupdate/swupdate.in && . /etc/swupdate/swupdate.in

function update_cmdline(){
    get_standby_root
    sed -i "s%root=\/dev\/mmcblk0p[[:digit:]]%root=$STANDBY_ROOT%" /boot/cmdline.txt
}


function preinst_actions(){
    get_standby_root
    if [ -e $STANDBY_ROOT ] ;
    then
	printf "Updating %s" $STANDBY_ROOT
    else
	printf "standby root %s not found!" $STANDBY_ROOT
	exit 1
    fi
}


function postinst_actions(){
    update_cmdline
    sync
    printf "rebooting"
    reboot
}


case "$1" in
    preinst)
	preinst_actions
    ;;
    postinst)
	postinst_actions
    ;;
    *)
	echo "Usage: $0 {preinst|postinst}"
	exit 1
esac

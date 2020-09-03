#!/bin/sh

################################################################################
# Raspberry Pi updates /boot/cmdline.txt
################################################################################
set -e
test -e /etc/swupdate/swupdate.in && . /etc/swupdate/swupdate.in

function update_cmdline(){
    get_standby_root
    sed -i "s%root=\/dev\/mmcblk0p[[:digit:]]%root=$STANDBY_ROOT%" /boot/cmdline.txt
}

function mark_update(){
    mount /dev/standby_root /mnt
    now
    echo $TS > /mnt/update-ok
}

log_info "$0 started"
update_cmdline
mark_update
sync
log_info "$0 done - rebooting"
reboot

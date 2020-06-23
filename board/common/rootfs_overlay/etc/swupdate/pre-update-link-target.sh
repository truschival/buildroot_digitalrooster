#!/bin/sh
#Simple pre-udpate script to create link to standby root partition

SWUPDATE_IN_FILE=/etc/swupdate/swupdate.in

test -e $SWUPDATE_IN_FILE || {
    echo " Failure $SWUPDATE_IN_FILE not found!"
    exit -1
}
. $SWUPDATE_IN_FILE

log_info "$0 starting"

# Create link to standby root file system (exits -1 for failure)
link_update_target

# Check if we succeeded (exits -2 for failure)
check_standby_root_link

log_info "$0 done"


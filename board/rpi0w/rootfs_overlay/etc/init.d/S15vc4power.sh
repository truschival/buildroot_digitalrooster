#!/bin/sh

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
SYSFS_NODE="/sys/devices/platform/soc/20c00000.v3d/power/control"
PID=

NAME="VC4 Power Management "
DESC="Fixes system freeze when VC4/V3D is disabled by power management"

start() {
        printf "disabling: $NAME"
	if [ -x $SYSFS_NODE ] ;
	then
	    printf "Powermanagement node not found!"
	    exit 1
	fi
	echo on > $SYSFS_NODE
        [ $? = 0 ] && echo "OK" || echo "FAIL"
}

stop() {
        printf "(re-)enabling: $NAME"
	echo auto > $SYSFS_NODE
        [ $? = 0 ] && echo "OK" || echo "FAIL"
}
restart() {
        stop
        start
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart|reload)
        restart
        ;;
  *)
        echo "Usage: $0 {start|stop|restart}"
        exit 1
esac

exit $?

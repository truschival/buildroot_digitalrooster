#!/bin/sh

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/bin/swupdate"

test -x "$DAEMON" || exit 0

NAME="SWUpdate"
DESC="Embedded systems updater"
PID=/var/run/swupdate.pid
SWUPDATE_CFG=/etc/default/swupdate.cfg

test -r $SWUPDATE_CFG || exit -1

# Add local processor id as serial number to swupdate.cfg
PROC_SERIAL=$(grep Serial /proc/cpuinfo | sed -E 's/(.*) ([^[:space:]]*)$/\2/g')
sed -i -e "s%@PROC_SERIAL@%$PROC_SERIAL%g" $SWUPDATE_CFG
# Add Hostname
HOSTNAME=$(hostname)
sed -i -e "s%@HOSTNAME@%$HOSTNAME%g" $SWUPDATE_CFG
# Add Revision info
test -r /etc/digitalrooster_build_info && . /etc/digitalrooster_build_info
sed -i -e "s%@BUILD_DATE@%$BUILD_DATE%g" $SWUPDATE_CFG
sed -i -e "s%@DIST_REVISION@%$REVISION%g" $SWUPDATE_CFG
KERNEL_REVISION=$(uname -r)
sed -i -e "s%@KERNEL_REVISION@%$KERNEL_REVISION%g" $SWUPDATE_CFG


# Start
start() {
    printf "Starting $NAME: "
    start-stop-daemon -S -v -b -m -p $PID \
                      -x  $DAEMON -- -f $SWUPDATE_CFG -w "" -u "-c 2"
    [ $? = 0 ] && echo "OK" || echo "FAIL"
}

stop() {
    printf "Stopping $NAME: "
    start-stop-daemon -K -q -p $PID
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

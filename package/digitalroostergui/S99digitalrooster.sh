#!/bin/sh

# Avoid excessive stat(/etc/localtime) calls
export TZ=:/etc/localtime

source /etc/default/digitalrooster-qt.conf

##
# Config files in /root/.config
##
export HOME=/root

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/bin/DigitalRoosterGui"
DAEMON_ARGS="--confpath=/persistent/digitalrooster.json --cachedir=/persistent/cache --logfile=/persistent/digitalrooster.log"

test -x "$DAEMON" || exit 0

NAME="DigitalRoosterGUI"
DESC="Alarm clock GUI"
PID=/var/run/digitalrooster.pid
PID_APLAY=/var/run/aplay.pid

start() {
    printf "Starting $NAME: "

    start-stop-daemon -S -v -b -m -p $PID \
                      -x  $DAEMON -- $DAEMON_ARGS

    [ $? = 0 ] && echo "OK" || echo "FAIL"
}

stop() {
    printf "Stopping aplay: "
    start-stop-daemon -K -q -p $PID_APLAY
    [ $? = 0 ] && echo "OK" || echo "FAIL"
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



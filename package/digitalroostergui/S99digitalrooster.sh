#!/bin/sh

# Avoid excessive stat(/etc/localtime) calls
export TZ=:/etc/localtime

# QT/Framebuffer related settings
source /etc/default/digitalrooster.conf

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON=$DR_EXE
DAEMON_ARGS="--config=$DATA_PART/digitalrooster.json \
	     --cachedir=$DATA_PART/cache \
             --logfile=$DR_LOG_FILE"

NAME="DigitalRoosterGUI"
DESC="Alarm clock GUI"
PID=$DR_PID_FILE

start() {
    printf "Starting $NAME: "

    start-stop-daemon -S -v -b -m -p $PID \
                      -x  $DAEMON -- $DAEMON_ARGS

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



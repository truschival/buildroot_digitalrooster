#!/bin/sh

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/bin/swupdate"

test -x "$DAEMON" || exit 0

NAME="Swupdate"
DESC="embedded systems updater"
PID=/var/run/swupdate.pid

start() {
    printf "Starting $NAME: "
    start-stop-daemon -S -v -b -m -p $PID \
                      -x  $DAEMON -- -L -w "-r /var/www/swupdate"
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



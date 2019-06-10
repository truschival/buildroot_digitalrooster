#!/bin/sh

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/bin/fbcp"
NAME="Framebuffer copy utility"
PID=/var/run/fbcp.pid

test -x "$DAEMON" || exit 0

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

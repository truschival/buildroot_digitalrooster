#!/bin/sh

ALSA_STATE=/etc/asound.state
ALSA_CARD=0

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/sbin/alsactl"
PID=/var/run/alsactl.pid

test -x "$DAEMON" || exit 0

NAME="Alsa Settings"
DESC=""

start() {
        printf "Restoring Alsa settings: "
        $DAEMON init $ALSA_CARD
        $DAEMON -f $ALSA_STATE restore $ALSA_CARD
        $DAEMON -f $ALSA_STATE -b -e $PID -p 30 daemon $ALSA_CARD       
        [ $? = 0 ] && echo "OK" || echo "FAIL"
}

stop() {
        printf "Storing Alsa settings : "
                $DAEMON -f $ALSA_STATE kill save_and_quit
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

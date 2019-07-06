#!/bin/sh
# WPA Supplicant for WLAN authentication
#
set -e
DAEMON=/usr/sbin/wpa_supplicant
DAEMON_ARGS="-i wlan0 -Dwext -c/etc/wpa_supplicant.conf "
PIDFILE=/var/run/wpa_supplicant.pid

case "$1" in
    start)
	printf "Starting WPA Supplicant:"
	start-stop-daemon -p $PIDFILE -x $DAEMON -v -m -b -S -- $DAEMON_ARGS
	[ $? = 0 ] && echo "OK" || echo "FAIL"
	;;
    stop)
	printf "Stopping WPA Supplicant: "
	start-stop-daemon -p $PIDFILE -K
	[ $? = 0 ] && echo "OK" || echo "FAIL"
	;;
    restart|reload)
	"$0" stop
	"$0" start
	;;
    *)
	echo "Usage: $0 {start|stop|restart}"
	exit 1
esac

exit $?

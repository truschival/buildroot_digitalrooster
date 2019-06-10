#!/bin/sh

export QT_QPA_EGLFS_HEIGHT=240
export QT_QPA_EGLFS_WIDTH=320
export QT_QPA_EGLFS_PHYSICAL_WIDTH=58
export QT_QPA_EGLFS_PHYSICAL_HEIGHT=43

#export QT_QPA_EGLFS_FB=/dev/fb0
export QT_QPA_FB_FORCE_FULLSCREEN=1
export QT_QPA_EVDEV_TOUCHSCREEN_PARAMETERS=/dev/input/event0:rotate=90

# export QT_QPA_EGLFS_DEBUG=1
# export QT_DEBUG_PLUGINS=1

export QT_LOGGING_RULES="*.debug=false;*qml=true;DigitalRooster.VolumeButton.debug=true"

##
# Config files in /root/.config
##
export HOME=/root

PATH="/sbin:/bin:/usr/sbin:/usr/bin"
DAEMON="/usr/bin/DigitalRoosterGui"

test -x "$DAEMON" || exit 0

NAME="DigitalRoosterGUI"
DESC="Alarm clock GUI"
PID=/var/run/digitalrooster.pid

start() {
    printf "Starting $NAME: "

    start-stop-daemon -S -v -b -m -p $PID \
                      -x  $DAEMON -- $DAEMON_ARGS

	# echo 22 > /sys/class/gpio/export
	# echo in > /sys/class/gpio/gpio22/direction

	# echo "0" > /sys/class/backlight/soc\:backlight/brightness
	# gpio -g mode 13 pwm
	# gpio pwmc 1000
	# gpio pwmr 200
	# gpio pwm-ms
	# gpio -g pwm 13 200

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

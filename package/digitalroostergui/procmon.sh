#!/bin/sh

# Script called by cron to check if digital rooster is still alive
# if not gather log data and restart it

NOW=$(date +%y-%m-%d_%H:%M:%S)

# Contains settings e.g. PIDFILE
. /etc/default/digitalrooster.conf

LOG_ARCHIVE=$DATA_PART/crash-$NOW.tar

collect_logs() {
    printf "collecting logs"
    # kernel log
    dmesg > $DATA_PART/kern.log
    tar -cf $LOG_ARCHIVE \
	$DATA_PART/kern.log \
	$DR_LOG_FILE \
	/var/log/messages
    gzip $LOG_ARCHIVE
}

killall_and_start() {
    killall $DR_EXE
    /etc/init.d/S99digitalrooster.sh start
}

# if we don't have a PID, start the process
[ -r $DR_PID_FILE ] || killall_and_start

# check if the pid matches the command line, we could use pgrep if we had it
DR_PID=$(cat $DR_PID_FILE)
grep -q $DR_EXE /proc/$DR_PID/cmdline
process_alive=$?

if [ $process_alive -ne 0 ] ;
then
    collect_logs
    /etc/init.d/S99digitalrooster.sh start
fi

#!/bin/bash

case "$1" in
    start)
	nohup /home/pi/dc1100.sh > /var/log/dc1100.log &
	echo $! > /var/run/dc1100.pid
	;;
    stop)
	kill `cat /var/run/dc1100.pid`
	;;
    *)
	echo "usage: dc1100 {start|stop}"
	exit 1
	;;
 esac
 exit $?

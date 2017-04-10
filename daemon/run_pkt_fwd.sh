#!/bin/bash

usage() {
    echo missing working root directory path
	echo usage: $0 [start/restart/check/stop] PATH
    echo example: $0 check /home/pi/lora-net/
    exit
}

#
# Check input parameters
#
if [ -z "$2" ]; then 
    usage
fi

#
# Global variables
#
DIR=$2

#
# Functions
#
start() {
    echo "Start packet forwarder..."
    cd $DIR/lora_gateway
    ./reset_lgw.sh start
    cd $DIR/packet_forwarder/lora_pkt_fwd
    ./lora_pkt_fwd
}

stop() {
    echo "Stop packet forwarder"
    sudo killall lora_pkt_fwd 
}

check() {
    ps -ef | grep -v grep | grep -w 'lora_pkt_fwd' > /dev/null
    result=$?
    if [ "${result}" -eq "0" ] ; then
         echo "`date`: lora_pkt_fwd is already running"
         exit 0
    fi
    start
}

#
# Main
#

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    check)
        check
        ;;
    *)
        usage
        exit 1
        ;;
esac

exit 0



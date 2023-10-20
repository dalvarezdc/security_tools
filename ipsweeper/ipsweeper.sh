#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 <network>"
    echo "Example: $0 192.168.1"
    exit
fi

network=$1

for ip in $(seq 1 254); do
    ping -c 1 $network.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
done

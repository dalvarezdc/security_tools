#!/bin/bash

set -euo pipefail

if [ "$1" == "" ]; then
    echo "Usage: $0 <network>"
    echo "Example: $0 192.168.1"
    exit 1
fi

network=$1

# Validate network format (basic check for first 3 octets)
if ! [[ $network =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    echo "Invalid network format. Use format: 192.168.1"
    exit 1
fi

for ip in $(seq 1 254); do
    ping -c 1 $network.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" &
done

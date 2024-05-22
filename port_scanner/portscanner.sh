#!/bin/bash

# Port scanner in Bash with parallel scanning, logging, and selective checking
if [[ $# -lt 3 ]]; then
    echo "Usage: $0 <TARGET_IP> <START_PORT> <END_PORT> [OPTION]"
    echo "OPTION can be 'open', 'closed' or left blank for both."
    exit 1
fi

TARGET_IP=$1
START_PORT=$2
END_PORT=$3
OPTION=$4
LOG_FILE="scan_results_$(date +%Y%m%d%H%M%S).csv"

# A list of common ports and their typical uses.
declare -A PORT_MEANINGS
PORT_MEANINGS=( [21]="FTP" [22]="SSH" [23]="Telnet" [25]="SMTP" [53]="DNS" [80]="HTTP" [110]="POP3" [143]="IMAP" [443]="HTTPS" [465]="SMTPS" )

# Validate IP address format
if ! [[ $TARGET_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid IP address format."
    exit 1
fi

# Validate port numbers
if ! [[ $START_PORT =~ ^[0-9]+$ && $END_PORT =~ ^[0-9]+$ && $START_PORT -le $END_PORT ]]; then
    echo "Invalid port range."
    exit 1
fi

# Validation for the OPTION
if [[ -n "$OPTION" && "$OPTION" != "open" && "$OPTION" != "closed" ]]; then
    echo "Invalid option. Please use 'open', 'closed' or leave blank for both."
    exit 1
fi

echo "Scanning $TARGET_IP from port $START_PORT to $END_PORT..."

check_port() {
    local port=$1
    if [ "$OPTION" == "open" ] || [ -z "$OPTION" ]; then
        (echo > /dev/tcp/$TARGET_IP/$port) > /dev/null 2>&1 && {
            echo "$port,open,${PORT_MEANINGS[$port]:-Unknown}"
            echo "$port,open,${PORT_MEANINGS[$port]:-Unknown}" >> $LOG_FILE
        }
    fi
    if [ "$OPTION" == "closed" ] || [ -z "$OPTION" ]; then
        (echo > /dev/tcp/$TARGET_IP/$port) > /dev/null 2>&1 || {
            echo "$port,closed"
            echo "$port,closed" >> $LOG_FILE
        }
    fi
}

# Initialize CSV with headers
echo "Port,Status,Service" > $LOG_FILE

export -f check_port
export TARGET_IP
export PORT_MEANINGS
export LOG_FILE
export OPTION

# -P 50 makes xargs run up to 50 processes at once.
seq $START_PORT $END_PORT | xargs -I % -P 50 bash -c 'check_port "%"'

echo "Scan completed. Results saved to $LOG_FILE."

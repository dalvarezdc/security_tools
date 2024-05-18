#!/bin/bash

# Find INTERNET_IF (Internet Interface Name)
INTERNET_IF=$(ip route | grep default | awk '{print $5}')
echo "INTERNET_IF: $INTERNET_IF"

# Prompt user to connect to VPN before running the next part
echo "Please connect to your VPN and then press [Enter] to continue."
read -p ""

# Find VPN_IF (VPN Interface Name)
VPN_IF=$(ip link | grep -o 'tun[0-9]\+')
echo "VPN_IF: $VPN_IF"

# Find VPN_SERVER (VPN Server Address) from OpenVPN configuration file
echo "Please provide the path to your OpenVPN configuration file (e.g., /path/to/your/vpnconfig.ovpn):"
read -p "Path: " VPN_CONFIG_PATH
VPN_SERVER=$(grep '^remote ' $VPN_CONFIG_PATH | awk '{print $2}')
echo "VPN_SERVER: $VPN_SERVER"

# Find LOCAL_NET (Local Network)
LOCAL_NET=$(ip route | grep $INTERNET_IF | grep -o '^[0-9\.]\+\/[0-9]\+')
echo "LOCAL_NET: $LOCAL_NET"

echo -e "\nSummary of Variables:"
echo "INTERNET_IF: $INTERNET_IF"
echo "VPN_IF: $VPN_IF"
echo "VPN_SERVER: $VPN_SERVER"
echo "LOCAL_NET: $LOCAL_NET"

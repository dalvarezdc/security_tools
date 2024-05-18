#!/bin/bash

# Interface connected to the Internet (before connecting to VPN)
INTERNET_IF="eth0"

# VPN interface name (typically 'tun0' for OpenVPN)
VPN_IF="tun0"

# VPN server address
VPN_SERVER="your.vpn.server"

# Local network (change according to your local network settings)
LOCAL_NET="192.168.1.0/24"

# Function to set up the firewall
setup_killswitch() {
    echo "Setting up VPN killswitch..."

    # Flush existing rules
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    iptables -X

    # Allow local traffic on loopback and LAN
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    iptables -A INPUT -s $LOCAL_NET -j ACCEPT
    iptables -A OUTPUT -d $LOCAL_NET -j ACCEPT

    # Allow traffic on the VPN interface
    iptables -A INPUT -i $VPN_IF -j ACCEPT
    iptables -A OUTPUT -o $VPN_IF -j ACCEPT

    # Allow traffic to the VPN server
    iptables -A OUTPUT -o $INTERNET_IF -d $VPN_SERVER -j ACCEPT

    # Drop all other traffic
    iptables -A INPUT -j DROP
    iptables -A OUTPUT -j DROP

    echo "Killswitch setup complete."
}

# Function to tear down the firewall
teardown_killswitch() {
    echo "Tearing down VPN killswitch..."

    # Flush existing rules
    iptables -F
    iptables -t nat -F
    iptables -t mangle -F
    iptables -X

    echo "Killswitch teardown complete."
}

# Check if OpenVPN is running
check_vpn() {
    if ip a | grep -q $VPN_IF; then
        echo "VPN is connected."
        return 0
    else
        echo "VPN is not connected."
        return 1
    fi
}

# Main script logic
case "$1" in
    start)
        setup_killswitch
        ;;
    stop)
        teardown_killswitch
        ;;
    status)
        check_vpn
        ;;
    *)
        echo "Usage: $0 {start|stop|status}"
        exit 1
        ;;
esac
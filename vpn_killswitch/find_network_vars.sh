#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

validate_file_path() {
    local file_path="$1"
    
    # Check for path traversal attempts
    if [[ "$file_path" == *".."* ]] || [[ "$file_path" == *"~"* ]]; then
        log_error "Invalid file path: potential path traversal detected"
        return 1
    fi
    
    # Check if file exists and is readable
    if [[ ! -f "$file_path" ]]; then
        log_error "File does not exist: $file_path"
        return 1
    fi
    
    if [[ ! -r "$file_path" ]]; then
        log_error "File is not readable: $file_path"
        return 1
    fi
    
    return 0
}

# Find INTERNET_IF (Internet Interface Name)
log_info "Finding internet interface..."
INTERNET_IF=$(ip route | grep default | awk '{print $5}' | head -n1)
if [[ -z "$INTERNET_IF" ]]; then
    log_error "Could not determine internet interface"
    exit 1
fi
log_info "INTERNET_IF: $INTERNET_IF"

# Prompt user to connect to VPN before running the next part
log_info "Please connect to your VPN and then press [Enter] to continue."
read -r

# Find VPN_IF (VPN Interface Name)
log_info "Finding VPN interface..."
VPN_IF=$(ip link | grep -o 'tun[0-9]\+' | head -n1)
if [[ -z "$VPN_IF" ]]; then
    log_warn "Could not find VPN interface (tun*). Trying alternative interfaces..."
    VPN_IF=$(ip link | grep -o 'wg[0-9]\+' | head -n1)
    if [[ -z "$VPN_IF" ]]; then
        log_error "Could not determine VPN interface"
        exit 1
    fi
fi
log_info "VPN_IF: $VPN_IF"

# Find VPN_SERVER (VPN Server Address) from OpenVPN configuration file
log_info "Please provide the path to your OpenVPN configuration file:"
log_info "Example: /etc/openvpn/client.conf or ~/vpn/config.ovpn"
read -p "Path: " VPN_CONFIG_PATH

if ! validate_file_path "$VPN_CONFIG_PATH"; then
    exit 1
fi

VPN_SERVER=$(grep '^remote ' "$VPN_CONFIG_PATH" | awk '{print $2}' | head -n1)
if [[ -z "$VPN_SERVER" ]]; then
    log_error "Could not find VPN server in configuration file"
    exit 1
fi
log_info "VPN_SERVER: $VPN_SERVER"

# Find LOCAL_NET (Local Network)
log_info "Finding local network..."
LOCAL_NET=$(ip route | grep "$INTERNET_IF" | grep -o '^[0-9\.]\+\/[0-9]\+' | head -n1)
if [[ -z "$LOCAL_NET" ]]; then
    log_error "Could not determine local network"
    exit 1
fi
log_info "LOCAL_NET: $LOCAL_NET"

echo -e "\nSummary of Variables:"
echo "INTERNET_IF: $INTERNET_IF"
echo "VPN_IF: $VPN_IF"
echo "VPN_SERVER: $VPN_SERVER"
echo "LOCAL_NET: $LOCAL_NET"

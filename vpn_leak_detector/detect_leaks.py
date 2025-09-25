import os
import sys
import time
import socket
import logging

# Add parent directory to path to import our modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from config import config
from utils import get_public_ip, logger

# Set your VPN server's expected public IP address
VPN_IP = config.get_vpn_config()['server_ip']


# Function to check if DNS resolves through the VPN
def check_dns_via_vpn(vpn_ip):
    """Check for DNS leaks by resolving a test domain."""
    try:
        dns_servers = socket.gethostbyname_ex("example.com")[2]
        for server in dns_servers:
            if server != vpn_ip:
                logger.warning(f"Potential DNS leak detected! DNS resolved via {server} instead of VPN.")
                return False
            else:
                logger.info("DNS is routed through the VPN.")
                return True
    except socket.gaierror as e:
        logger.error(f"DNS resolution failed: {e}")
        return False


# Monitoring loop to check leaks periodically
def monitor_vpn_leaks(interval_seconds=60):
    """
    Monitor VPN for IP and DNS leaks periodically.
    
    Args:
        interval_seconds: Time between checks in seconds
    """
    if VPN_IP == "YOUR_VPN_SERVER_IP":
        logger.error("VPN_SERVER_IP not configured. Please set the environment variable.")
        return
    
    logger.info(f"Starting VPN leak monitoring. Expected VPN IP: {VPN_IP}")
    
    try:
        while True:
            public_ip = get_public_ip(timeout=config.get_vpn_config()['timeout'])
            
            if not public_ip:
                logger.error("Failed to retrieve public IP address")
            elif public_ip != VPN_IP:
                logger.warning(f"Possible IP leak detected. Current IP: {public_ip}, Expected: {VPN_IP}")
            else:
                logger.info(f"VPN is working correctly. Current IP: {public_ip}")

            # Check for DNS leaks
            check_dns_via_vpn(VPN_IP)

            # Add sleep interval before next check
            time.sleep(interval_seconds)
            
    except KeyboardInterrupt:
        logger.info("VPN monitoring stopped by user")
    except Exception as e:
        logger.error(f"Unexpected error in VPN monitoring: {e}")


# Set an interval (in seconds) for checking VPN leaks
monitor_interval = 60  # Check every 60 seconds
monitor_vpn_leaks(monitor_interval)

import requests
import time
import socket

# Set your VPN server's expected public IP address
VPN_IP = "YOUR_VPN_SERVER_IP"


# Function to get the public IP
def get_public_ip():
    try:
        response = requests.get("https://api.ipify.org")
        return response.text
    except Exception as e:
        print(f"Error retrieving public IP: {e}")
        return None


# Function to check if DNS resolves through the VPN
def check_dns_via_vpn(vpn_ip):
    dns_servers = socket.gethostbyname_ex("example.com")[2]
    for server in dns_servers:
        if server != vpn_ip:
            print(
                f"Warning: Potential DNS leak detected! DNS resolved via {server} instead of VPN."
            )
        else:
            print("DNS is routed through the VPN.")


# Monitoring loop to check leaks periodically
def monitor_vpn_leaks(interval_seconds=60):
    while True:
        public_ip = get_public_ip()
        if public_ip and public_ip != VPN_IP:
            print(f"Warning: Possible IP leak detected. Current IP: {public_ip}")
        else:
            print(f"VPN is working correctly. Current IP: {public_ip}")

        # Check for DNS leaks
        check_dns_via_vpn(VPN_IP)

        # Add sleep interval before next check
        time.sleep(interval_seconds)


# Set an interval (in seconds) for checking VPN leaks
monitor_interval = 60  # Check every 60 seconds
monitor_vpn_leaks(monitor_interval)

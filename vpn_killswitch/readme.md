# Find Network Variables Script

This README provides clear instructions on how to use the `find_network_vars.sh` script to identify necessary network variables for configuring an OpenVPN killswitch.


## Prerequisites

- A Linux distribution with `ip` and `awk` installed.
- OpenVPN installed and configured.
- Basic understanding of network interfaces on your system.

## Usage

### 1. Save the Script

Save the following script as `find_network_vars.sh`:
This script helps you find the necessary network variables required to set up an OpenVPN killswitch. It will identify your internet interface, VPN interface, VPN server address, and local network.



### 2. Make the Script Executable

Run the following command to make the script executable:

```bash
chmod +x find_network_vars.sh
```

### 3. Run the Script

Execute the script to find the required network variables:

```bash
./find_network_vars.sh
```

### 4. Follow the Prompts

- The script will automatically identify and display your internet interface (`INTERNET_IF`).
- You will be prompted to connect to your VPN before proceeding.
- After connecting to your VPN, press `[Enter]` to continue.
- The script will identify and display your VPN interface (`VPN_IF`).
- You will be prompted to provide the path to your OpenVPN configuration file to extract the VPN server address (`VPN_SERVER`).
- The script will then identify and display your local network (`LOCAL_NET`).

### 5. Use the Identified Variables

After running the script, use the displayed values to configure your OpenVPN killswitch script.

## Example Output

```
INTERNET_IF: eth0
Please connect to your VPN and then press [Enter] to continue.

VPN_IF: tun0
Please provide the path to your OpenVPN configuration file (e.g., /path/to/your/vpnconfig.ovpn):
Path: /path/to/your/vpnconfig.ovpn
VPN_SERVER: your.vpn.server
LOCAL_NET: 192.168.1.0/24

Summary of Variables:
INTERNET_IF: eth0
VPN_IF: tun0
VPN_SERVER: your.vpn.server
LOCAL_NET: 192.168.1.0/24
```

## Important Notes

- Ensure that you are connected to your VPN before running the script to identify the VPN interface (`VPN_IF`).
- Verify the path to your OpenVPN configuration file is correct when prompted.
- The script assumes typical naming conventions for network interfaces. Adjustments might be needed for non-standard configurations.

## License

This script is provided "as is", without warranty of any kind. Use it at your own risk.


---

# OpenVPN Killswitch Script

This script sets up a killswitch for your OpenVPN connection, ensuring that all internet traffic is blocked if the VPN connection drops. This prevents any unencrypted traffic from leaking.

## Prerequisites

- A Linux distribution with `iptables` installed.
- OpenVPN installed and configured.
- Basic understanding of network interfaces on your system.

## Usage

### 1. Save the Script

Save the script as `openvpn_killswitch.sh`.


### 2. Make the Script Executable

Run the following command to make the script executable:

```bash
chmod +x openvpn_killswitch.sh
```

### 3. Modify Variables

Edit the script and replace the following variables with your actual settings:

- `INTERNET_IF`: Your internet interface name (e.g., `eth0`, `wlan0`).
- `VPN_IF`: Your VPN interface name (typically `tun0` for OpenVPN).
- `VPN_SERVER`: Your VPN server address.
- `LOCAL_NET`: Your local network (e.g., `192.168.1.0/24`).

### 4. Run the Script

- To start the killswitch, run:

    ```bash
    ./openvpn_killswitch.sh start
    ```

- To stop the killswitch, run:

    ```bash
    ./openvpn_killswitch.sh stop
    ```

- To check the VPN status, run:

    ```bash
    ./openvpn_killswitch.sh status
    ```

## How It Works

- The script sets up `iptables` rules to block all traffic except through the VPN interface (`VPN_IF`) and allows traffic only to the VPN server (`VPN_SERVER`).
- When the VPN connection is active, the script allows traffic through the VPN interface.
- If the VPN connection drops, all internet traffic is blocked, ensuring no unencrypted traffic leaks.

## Important Notes

- Make sure to test the script in a safe environment to ensure it works as expected.
- Be careful when modifying firewall rules, as incorrect rules can block your internet connection entirely.
- Ensure you have a way to access your system (e.g., physical access or an out-of-band management interface) in case the script blocks your connection unexpectedly.

## License

This script is provided "as is", without warranty of any kind. Use it at your own risk.

---

This README provides a clear overview of the script, its purpose, and how to use it, ensuring that users can set up and manage their OpenVPN killswitch effectively.
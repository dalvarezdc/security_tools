#!/bin/bash

# Define the directory containing the OpenVPN configuration files
CONFIG_DIR="$HOME/Documents/mullvad_openvpn_linux_all_all/mullvad_config_linux"

# Change to the specified directory
if cd "$CONFIG_DIR"; then
    echo "Successfully changed to directory: $CONFIG_DIR"
else
    echo "Error: Unable to change to directory: $CONFIG_DIR"
    exit 1
fi

# List all available OpenVPN configuration files (usually with .ovpn extension)
echo "Available OpenVPN configurations:"
ls *.conf

# Prompt the user to select an OpenVPN file
read -p "Enter the name of the OpenVPN file to use (without path): " selected_file

# Validate that the selected file exists
if [[ ! -f "$selected_file" ]]; then
    echo "Error: File '$selected_file' does not exist in the specified directory."
    exit 1
fi

# Start OpenVPN with the selected configuration file
sudo openvpn --config "$selected_file"

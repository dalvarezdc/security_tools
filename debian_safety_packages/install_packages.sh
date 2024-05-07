#!/bin/bash

# Function to ask the user if they want to install a specific package
install_package() {
    local package=$1
    read -p "Do you want to install $package? (yes/no): " response

    case $response in
        [yY]|[yY][eE][sS])
            sudo apt update
            sudo apt install -y $package
            ;;
        [nN]|[nN][oO])
            echo "Skipping $package installation."
            ;;
        *)
            echo "Invalid response. Skipping $package installation."
            ;;
    esac
}

echo "Starting the installation process..."

install_package "ufw"
install_package "fail2ban"
install_package "apparmor"
install_package "wireguard"

echo "Installation process completed!"

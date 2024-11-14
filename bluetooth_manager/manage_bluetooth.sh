#!/bin/bash

# Set the Bluetooth adapter name (usually "hci0")
ADAPTER="hci0"

# Initialize option variables
DISABLE_BLUETOOTH="no"
SET_CLASS="no"
DISABLE_DISCOVERABILITY="no"
SET_AUTH_TIMEOUT="no"
DISABLE_UNKNOWN_PAIRING="no"
ENABLE_ENCRYPTION="no"
RESTRICT_TO_TRUSTED="no"
RESTART_SERVICE="no"

OPTION_COUNT=0

function usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  --disable-bluetooth           Disable Bluetooth"
    echo "  --set-class                   Set Bluetooth device class to '0x00000000'"
    echo "  --disable-discoverability     Disable Bluetooth discoverability"
    echo "  --set-auth-timeout            Set Bluetooth authentication timeout to 30 seconds"
    echo "  --disable-unknown-pairing     Disable pairing with unknown devices"
    echo "  --enable-encryption           Enable encryption for all Bluetooth connections"
    echo "  --restrict-to-trusted         Restrict Bluetooth connections to only trusted devices"
    echo "  --restart-service             Restart the Bluetooth service"
    echo "  --all                         Apply all settings"
    exit 1
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        --disable-bluetooth)
            DISABLE_BLUETOOTH="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --set-class)
            SET_CLASS="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --disable-discoverability)
            DISABLE_DISCOVERABILITY="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --set-auth-timeout)
            SET_AUTH_TIMEOUT="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --disable-unknown-pairing)
            DISABLE_UNKNOWN_PAIRING="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --enable-encryption)
            ENABLE_ENCRYPTION="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --restrict-to-trusted)
            RESTRICT_TO_TRUSTED="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --restart-service)
            RESTART_SERVICE="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        --all)
            DISABLE_BLUETOOTH="yes"
            SET_CLASS="yes"
            DISABLE_DISCOVERABILITY="yes"
            SET_AUTH_TIMEOUT="yes"
            DISABLE_UNKNOWN_PAIRING="yes"
            ENABLE_ENCRYPTION="yes"
            RESTRICT_TO_TRUSTED="yes"
            RESTART_SERVICE="yes"
            OPTION_COUNT=$((OPTION_COUNT+1))
            shift
            ;;
        *)
            echo "Unknown option: $key"
            usage
            ;;
    esac
done

if [ "$OPTION_COUNT" -eq 0 ]; then
    echo "No options specified."
    usage
fi

# Apply selected options

if [ "$DISABLE_BLUETOOTH" = "yes" ]; then
    echo "Disabling Bluetooth..."
    sudo hciconfig $ADAPTER down
fi

if [ "$SET_CLASS" = "yes" ]; then
    echo "Setting Bluetooth device class to '0x00000000'..."
    sudo hciconfig $ADAPTER class 0x00000000
fi

if [ "$DISABLE_DISCOVERABILITY" = "yes" ]; then
    echo "Disabling Bluetooth discoverability..."
    sudo hciconfig $ADAPTER discoverable no
fi

if [ "$SET_AUTH_TIMEOUT" = "yes" ]; then
    echo "Setting Bluetooth authentication timeout to 30 seconds..."
    sudo hciconfig $ADAPTER auth_timeout 30
fi

if [ "$DISABLE_UNKNOWN_PAIRING" = "yes" ]; then
    echo "Disabling pairing with unknown devices..."
    sudo hciconfig $ADAPTER secure yes
fi

if [ "$ENABLE_ENCRYPTION" = "yes" ]; then
    echo "Enabling encryption for all Bluetooth connections..."
    sudo hciconfig $ADAPTER encrypt yes
fi

if [ "$RESTRICT_TO_TRUSTED" = "yes" ]; then
    echo "Restricting Bluetooth connections to only trusted devices..."
    sudo hciconfig $ADAPTER trusted_devices_only yes
fi

if [ "$RESTART_SERVICE" = "yes" ]; then
    echo "Restarting Bluetooth service..."
    sudo systemctl restart bluetooth
fi

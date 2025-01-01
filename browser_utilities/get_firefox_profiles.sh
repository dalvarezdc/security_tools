#!/bin/bash
# If you can't find the FIREFOX_PROFILES_INI, run the following:
# find $HOME -name "profiles.ini"

# Set the Firefox profiles.ini path for both standard and Snap installations
STANDARD_PATH="$HOME/.mozilla/firefox/profiles.ini"
SNAP_PATH="$HOME/snap/firefox/common/.mozilla/firefox/profiles.ini"

# Determine which path to use
if [ -f "$STANDARD_PATH" ]; then
    FIREFOX_PROFILES_INI="$STANDARD_PATH"
elif [ -f "$SNAP_PATH" ]; then
    FIREFOX_PROFILES_INI="$SNAP_PATH"
else
    echo "Firefox profiles.ini file not found."
    exit 1
fi

echo "Using profiles.ini from: $FIREFOX_PROFILES_INI"
echo "Available Firefox Profiles:"
echo "---------------------------"

# Extract profile names and paths
grep -E "^\[Profile[0-9]+\]$" -A 5 "$FIREFOX_PROFILES_INI" | while read -r line; do
    case "$line" in
        Name=*)
            profile_name="${line#Name=}"
            ;;
        Path=*)
            profile_path="${line#Path=}"
            ;;
        *)
            continue
            ;;
    esac

    # Print profile information
    if [ -n "$profile_name" ] && [ -n "$profile_path" ]; then
        echo "Profile Name: $profile_name"
        echo "Profile Path: $HOME/.mozilla/firefox/$profile_path"
        echo "---------------------------"
        unset profile_name
        unset profile_path
    fi
done

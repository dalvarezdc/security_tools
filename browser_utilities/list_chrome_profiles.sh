#!/bin/bash

# Set the Chrome user data directory
CHROME_USER_DATA_DIR="$HOME/.config/google-chrome"

# Check if the directory exists
if [ ! -d "$CHROME_USER_DATA_DIR" ]; then
    echo "Chrome user data directory not found at $CHROME_USER_DATA_DIR"
    exit 1
fi

echo "Available Chrome Profiles:"
echo "--------------------------"

# Loop through profile directories
for profile_dir in "$CHROME_USER_DATA_DIR"/{Default,Profile*}; do
    if [ -d "$profile_dir" ]; then
        preferences_file="$profile_dir/Preferences"
        if [ -f "$preferences_file" ]; then
            # Try to extract the profile name using jq
            profile_name=$(jq -r '.profile.name' "$preferences_file" 2>/dev/null)

            # If the above doesn't yield a valid name, try the info_cache
            if [ -z "$profile_name" ] || [ "$profile_name" == "null" ]; then
                dir_name=$(basename "$profile_dir")
                profile_name=$(jq -r --arg dir_name "$dir_name" '.profile.info_cache[$dir_name].name' "$preferences_file" 2>/dev/null)
            fi

            # If still no name, default to directory name
            if [ -z "$profile_name" ] || [ "$profile_name" == "null" ]; then
                profile_name="$(basename "$profile_dir")"
            fi

            echo "Display Name: $profile_name"
            echo "Directory Name: $(basename "$profile_dir")"
            echo "-----------------------------"
        fi
    fi
done

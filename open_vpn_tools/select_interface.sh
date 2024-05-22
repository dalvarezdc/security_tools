#!/bin/bash

# Function to list network interfaces and capture the output
list_interfaces() {
    ip link show | awk -F: '/^[0-9]+: / {print $2}' | tr -d ' '
}

# Fetch all network interfaces into an array
interfaces=($(list_interfaces))

# Check if there are any network interfaces found
if [ ${#interfaces[@]} -eq 0 ]; then
    echo "No network interfaces found."
    exit 1
fi

# Display the interfaces and prompt the user to select one
echo "Available network interfaces:"
select selected_interface in "${interfaces[@]}"; do
    if [[ -n "$selected_interface" ]]; then
        echo "Selected interface: $selected_interface"
        break
    else
        echo "Invalid selection, please choose a valid number."
    fi
done

# Execute tcpdump on the selected interface
sudo tcpdump -i "$selected_interface"

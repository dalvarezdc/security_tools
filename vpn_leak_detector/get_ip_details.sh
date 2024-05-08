#!/bin/bash

# Fetch IP information from the ipinfo.io API
ip_info=$(curl -s https://ipinfo.io)

# Extract details using jq (requires jq to be installed) or grep/sed for specific fields
ip_address=$(echo "$ip_info" | grep '"ip":' | sed 's/.*: "\(.*\)",/\1/')
country=$(echo "$ip_info" | grep '"country":' | sed 's/.*: "\(.*\)",/\1/')
region=$(echo "$ip_info" | grep '"region":' | sed 's/.*: "\(.*\)",/\1/')
city=$(echo "$ip_info" | grep '"city":' | sed 's/.*: "\(.*\)",/\1/')
org=$(echo "$ip_info" | grep '"org":' | sed 's/.*: "\(.*\)",/\1/')
loc=$(echo "$ip_info" | grep '"loc":' | sed 's/.*: "\(.*\)",/\1/')

# Print the results
echo "IP Address: $ip_address"
echo "Country: $country"
echo "Region: $region"
echo "City: $city"
echo "Organization: $org"
echo "Location: $loc"

#  echo "$ip_info"

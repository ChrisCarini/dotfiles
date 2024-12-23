#!/bin/bash

# NOTE: This requires adding the below line via `sudo visudo`:
#   ccarini         ALL = (ALL) NOPASSWD: /usr/bin/wdutil
#
# You MUST do ^ before running this script.
echo "$(date +"%Y-%m-%d %H:%M:%S");$(sudo /usr/bin/wdutil info | \grep RSSI | awk '{print $3}' | head -n1)" >> ~/wifi_rssi.csv
# Remove any lines with '0' RSSI values (these started showing up because Bluetooth devices were included, and my headphones showed '0' all the time)
#sed -i '' '/^0$/d' ~/wifi_rssi.csv
#!/bin/bash

# NOTE: This requires adding the below line via `sudo visudo`:
#   ccarini         ALL = (ALL) NOPASSWD: /usr/bin/wdutil
#
# You MUST do ^ before running this script.
echo "$(date +"%Y-%m-%d %H:%M:%S");$(sudo /usr/bin/wdutil info | grep RSSI | awk '{print $3}')" >> ~/wifi_rssi.csv
#!/bin/bash

echo "$(date +"%Y-%m-%d %H:%M:%S");$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport --getinfo | grep agrCtlRSSI | awk '{split($0,a,":"); print a[2]}')" >> ~/wifi_rssi.csv
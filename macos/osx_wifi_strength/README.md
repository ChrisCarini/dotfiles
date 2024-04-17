# OSX Capture Wifi Signal Strength
Captures the wifi signal strength and logs to a file.

### NOTE: This requires adding the below line via `sudo visudo`

```
<username>         ALL = (ALL) NOPASSWD: /usr/bin/wdutil
```

You MUST do ^ before running this script.

## Install to crontab:
```
┌─(ccarini@ccarini-mn1)──(2020-08-18 @ 14:21:53)──( ~  ) 
└─$ > crontab -l
* * * * * ( /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )  
* * * * * ( sleep 10 ; /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )  
* * * * * ( sleep 20 ; /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )  
* * * * * ( sleep 30 ; /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )  
* * * * * ( sleep 40 ; /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )  
* * * * * ( sleep 50 ; /Users/ccarini/dotfiles/macos/osx_wifi_strength/captureWifiRSSI.sh )

┌─(ccarini@ccarini-mn1)──(2020-08-18 @ 14:21:54)──( ~  ) 
└─$ > 
```
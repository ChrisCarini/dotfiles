# OSX Capture Wifi Signal Strength
Captures the wifi signal strength and logs to a file.

## Install to crontab:
```
┌─(ccarini@ccarini-mn1)──(2020-08-18 @ 14:21:53)──( ~  ) 
└─$ > crontab -l
* * * * * ( /Users/ccarini/captureWifiRSSI.sh )  
* * * * * ( sleep 10 ; /Users/ccarini/captureWifiRSSI.sh )  
* * * * * ( sleep 20 ; /Users/ccarini/captureWifiRSSI.sh )  
* * * * * ( sleep 30 ; /Users/ccarini/captureWifiRSSI.sh )  
* * * * * ( sleep 40 ; /Users/ccarini/captureWifiRSSI.sh )  
* * * * * ( sleep 50 ; /Users/ccarini/captureWifiRSSI.sh )

┌─(ccarini@ccarini-mn1)──(2020-08-18 @ 14:21:54)──( ~  ) 
└─$ > 
```
#!/usr/bin/env bash

##
# See `Optimize macOS Networking` in https://wq6e.com/posts/2025-02-22_smb-macos-performance/
#
# At some point in the past, Apple made a decision to by default enable a setting called “delayed ACK” in
# kernel networking. This will cause the system to wait for a few packets before sending a TCP ACK packet 
# back to the source. ... Now with 1 gigabit fiber available to the home and multi-gig networking coming 
# down in price this isn’t really necessary anymore. It can also cause issues with SMB performance as the 
# SMB server will generally wait for ACK packets before continuing to send more data.
# 
# Disabling this will eliminate the bottleneck.
#   $ sudo sysctl net.inet.tcp.delayed_ack=0
#
# NOTE: Using `tee` here because `cat` was having permission issues: "line 14: /Library/LaunchDaemons/com.startup.sysctl.plist: Permission denied"
sudo tee /Library/LaunchDaemons/com.startup.sysctl.plist > /dev/null <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.startup.sysctl</string>
    <key>LaunchOnlyOnce</key>
    <true/>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/sbin/sysctl</string>
        <string>net.inet.tcp.delayed_ack=0</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF
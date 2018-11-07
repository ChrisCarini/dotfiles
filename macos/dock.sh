#!/bin/sh

##
# Remove all Dock Icons
##
dockutil --no-restart --remove all

##
# Add Dock Icons in the order we desire.
##
# Finder
dockutil --no-restart --add "/System/Library/CoreServices/Finder.app"
# O365
dockutil --no-restart --add "/Applications/Microsoft Outlook.app"
# Chrome
dockutil --no-restart --add "/Applications/Google Chrome.app"
# Term
dockutil --no-restart --add "/Applications/Utilities/Terminal.app"
# iTerm
dockutil --no-restart --add "/Applications/iTerm.app"
# IJ
dockutil --no-restart --add "/Applications/IntelliJ IDEA CE.app"
# Slack
dockutil --no-restart --add "/Applications/Slack.app"
# Activity Monitor
dockutil --no-restart --add "/Applications/Utilities/Activity Monitor.app"
# Teams
dockutil --no-restart --add "/Applications/Microsoft Teams.app"
# OneNote
dockutil --no-restart --add "/Applications/Microsoft OneNote.app"

##
# Restart Dock for icons to take effect.
##
killall Dock
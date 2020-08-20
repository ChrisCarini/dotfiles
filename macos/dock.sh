#!/usr/bin/env bash

##
# Make utilities available
#
# Needed because we make use of is-macos-catalina within this script.
##
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ..  && pwd )"
PATH="$DOTFILES_DIR/bin:$PATH"

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
if is-macos-catalina ; then
  dockutil --no-restart --add "/System/Applications/Utilities/Terminal.app"
else
  dockutil --no-restart --add "/Applications/Utilities/Terminal.app"
fi

# iTerm
dockutil --no-restart --add "/Applications/iTerm.app"
# IJ
dockutil --no-restart --add "/Applications/IntelliJ IDEA CE.app"
# Slack
dockutil --no-restart --add "/Applications/Slack.app"

# Activity Monitor
if is-macos-catalina ; then
  dockutil --no-restart --add "/System/Applications/Utilities/Activity Monitor.app"
else
  dockutil --no-restart --add "/Applications/Utilities/Activity Monitor.app"
fi

# Teams
dockutil --no-restart --add "/Applications/Microsoft Teams.app"
# OneNote
dockutil --no-restart --add "/Applications/Microsoft OneNote.app"

##
# Restart Dock for icons to take effect.
##
killall Dock
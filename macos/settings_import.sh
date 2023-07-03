#!/usr/bin/env bash

PATH="$DOTFILES_DIR/bin:$PATH"

# ===================================================
header "=" "Close any open System Preferences panes." # Prevents them from overriding settings we’re about to change"
# ===================================================
osascript -e 'tell application "System Preferences" to quit'

# -----------------------------
header "-" "Import All Domains"
# -----------------------------

echo "********* IMPORTING DOMAIN -globalDomain **********"
defaults import -globalDomain "$HOME/dotfiles/macos/settings/-globalDomain.plist"

for i in $(defaults domains | tr ',' '\n'); do
  echo "********* IMPORTING DOMAIN $i **********"
  defaults export "${i}" "$HOME/dotfiles/macos/settings/${i}.plist"
done

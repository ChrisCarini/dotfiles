#!/usr/bin/env bash

if ! [ -x "$(command -v mysides)" ]; then
  echo "'mysides' not installed - executing 'brew cask install mysides' as $(logname) ..."
  # Note: We run this as `su $(logname)` because the settings.sh file is run as sudo (for all the other commands)
  #       and brew will complain and not run if being run with elevated privs.
  su $(logname) -c 'brew cask install mysides'
fi
if [ -x "$(command -v mysides)" ]; then
  echo "'mysides' is installed."

  echo "Removing all existing folders from favorites menu..."
  mysides list | awk -F"->" '{print $1}' | xargs -I {} mysides remove "{}"

  echo "Adding folders to Finder favorites menu..."

  mysides add "Applications" file:///Applications/
  mysides add "Desktop" file:///Users/$USER/Desktop/
  mysides add "Documents" file:///Users/$USER/Documents/
  mysides add "Downloads" file:///Users/$USER/Downloads/
  mysides add "$USER" file:///Users/$USER/
  mysides add "Archive" file:///Users/$USER/Desktop/Archive/
  mysides add "tmp" file:///Users/$USER/tmp/
  mysides add "code" file:///Users/$USER/code
  mysides add "~DELETE THIS STUFF" file:///Users/$USER/Desktop/~DELETE%20THIS%20STUFF/
else
  echo "###################"
  echo "##    WARNING    ##"
  echo "###################"
  echo "##"
  echo "## mysides still is not installed. Nothing added to side bar."
  echo "##"
  echo "##    You can manually install mysides via:"
  echo "##        $ brew cask install mysides"
fi

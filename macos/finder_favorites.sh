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
  mysides remove all

  echo "Adding folders to Finder favorites menu..."

  mysides add "Applications" file:///Applications/
  mysides add "Desktop" file:///Users/$USER/Desktop/
  mysides add "Documents" file:///Users/$USER/Documents/
  mysides add "Downloads" file:///Users/$USER/Downloads/
  mysides add "$USER" file:///Users/$USER/
  mysides add "Archive" file:///Users/$USER/Desktop/Archive/
  mysides add "GitHub" file:///Users/$USER/GitHub
  mysides add "code" file:///Users/$USER/code
  mysides add "tmp" file:///Users/$USER/tmp/
  mysides add "Financial" file:///Users/$USER/Desktop/Archive/Personal/Financial/
  mysides add "5068 Tifton Way - HH" file:///Users/$USER/Desktop/Archive/Personal/Housing/House%20Hunting/2022%20-%20HOUSE%20HUNTING/5068%20Tifton%20Way/
  mysides add "5068 Tifton Way" file:///Users/$USER/Desktop/Archive/Personal/Housing/5068%20Tifton%20Way/
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

#!/usr/bin/env bash
if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

brew tap homebrew/cask-versions

# Install packages
apps=(
    activitywatch  # https://formulae.brew.sh/cask/activitywatch
#    atom
#    arduino
#    burp-suite
#    Caffeine
    docker  # This installs the OSX Docker Desktop Application
#    filezilla
    firefox
    flux
    google-chrome
#    google-chrome-canary
    gpg-suite
    hammerspoon  # Mostly as a replacement for `shiftit`.
    intellij-idea
    intellij-idea-ce
    iterm2
#    kitematic
#    mysqlworkbench
    mysides  # Needed to be able to manipulate Finder favorites - See https://github.com/mosen/mysides
    OmniDiskSweeper  # https://www.omnigroup.com/more
#    shiftit  # On 2022-01-31 this stopped working when in Zoom and/or MS Teams VCs. Switching to Hammerspoon.
    slack
#    spotify
#    sublime-text
    tunnelblick
#    virtualbox
#    visual-studio-code
    vlc
#    xquartz # For X11 forwarding - NOTE: THIS IS INSTALLED IN post-install.sh BECAUSE IT PROMPTS FOR PASSWORD.
)

for APPLICATION in "${apps[@]}"; do
  # NOTE: I used to check if the application was installed first.
  #       That was too hard to maintain for the benefit (ie, none),
  #       so I decided to remove the logic. Ahh, so simple. :)
  echo "============================="
  echo "Installing [$APPLICATION] ..."
  HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $APPLICATION
done

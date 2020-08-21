#!/usr/bin/env bash
####################################################
# Get current dir (so run this script from anywhere)
####################################################
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"

#################
# Banner Function
#################
function section() {
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w < ${#l})) && {
      b="$l"
      w="${#l}"
    }
  done
  echo "####${b//?/#}####"
  for l in "${s[@]}"; do
    printf '#   %*s%s   #\n' "-$w" "$l"
  done
  echo "####${b//?/#}####"
}

##
# Elevate privileges to sudo so we can avoid prompts throughout the installation.
##
# Ask for the administrator password upfront
echo "Prompting for sudo password upfront..."
sudo --validate

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

##
# Make utilities available
##
PATH="$DOTFILES_DIR/bin:$PATH"

if is-macos; then
  title "Updating Software and Installing XCode"
  sudo softwareupdate -i -a && xcode-select --install
fi

##
# Update dotfiles itself first
##
# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

#############################
title "Symlink core dotfiles"
#############################
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}; do
    [[ -f "$DOTFILE" ]] && ln -sfv "$DOTFILE" ~
done

###########################################
title "Install package managers & packages"
###########################################
if is-macos; then
  title "Installing brew"
  . "$DOTFILES_DIR/install/brew.sh"
  . "$DOTFILES_DIR/install/brew-cask.sh"
fi

##########################
title "Create directories"
##########################
mkdir ~/code
mkdir ~/tmp
mkdir ~/GitHub
mkdir ~/Desktop/~DELETE\ THIS\ STUFF
mkdir ~/Desktop/Archive
mkdir ~/Desktop/Screen\ Shots\ To\ Save

############################
title "Checkout source code"
############################
. "$DOTFILES_DIR/install/code.sh"
# Run work code bootstrap, should it exist
if [[ -f "$DOTFILES_DIR/work/install/code.sh" ]] ; then
. "$DOTFILES_DIR/work/install/code.sh"
else
    echo "No work/install/code.sh exists; not bootstraping work code!"
fi

##
# If OSX, let's do the dock + settings
##
if is-macos ; then
    # Change the default shell on OSX back to bash.
    chsh -s /bin/bash

    sudo . "$DOTFILES_DIR/macos/settings.sh"
    # Run dock.sh last, as the final step kills all items launched from the dock, including the terminal the install.sh
    #  script is running from.
    . "$DOTFILES_DIR/macos/dock.sh"
fi
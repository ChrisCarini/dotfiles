#!/usr/bin/env bash
##
# Get current dir (so run this script from anywhere)
##
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"

##
# Make utilities available
##
PATH="$DOTFILES_DIR/bin:$PATH"

##
# Update dotfiles itself first
##
# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

##
# Bunch of symlinks
##
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}; do
    [[ -f "$DOTFILE" ]] && ln -sfv "$DOTFILE" ~
done
# Override and .gitconfig / .gitignore_global with work specific configs
for DOTFILE in "$DOTFILES_DIR"/work/git/.{gitconfig,gitignore_global}; do
    [[ -f "$DOTFILE" ]] && ln -sfv "$DOTFILE" ~
done

##
# Package managers & packages
##
. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"

##
# Create directories
##
mkdir ~/code
mkdir ~/tmp
mkdir ~/GitHub
mkdir ~/Desktop/~DELETE\ THIS\ STUFF
mkdir ~/Desktop/Archive
mkdir ~/Desktop/Screen\ Shots\ To\ Save

##
# Checkout source code
##
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
    . "$DOTFILES_DIR/macos/settings.sh"
    # Run dock.sh last, as the final step kills all items launched from the dock, including the terminal the install.sh
    #  script is running from.
    . "$DOTFILES_DIR/macos/dock.sh"
fi
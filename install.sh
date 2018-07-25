#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Update dotfiles itself first
# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}; do
    [ -f "$DOTFILE" ] && ln -sfv "$DOTFILE" ~
done
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}.work; do
    ORIG_FILE_NAME=$(basename $DOTFILE)  # Get the filename
    ORIG_FILE_NAME=${ORIG_FILE_NAME%.work}  # Strip away the `.work` from the end
    [ -f "$DOTFILE" ] && ln -sfv "$DOTFILE" ~/"$ORIG_FILE_NAME"
done

# Package managers & packages
. "$DOTFILES_DIR/install/brew.sh"
. "$DOTFILES_DIR/install/brew-cask.sh"

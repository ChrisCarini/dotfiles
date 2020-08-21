#!/usr/bin/env bash

function echo_ri() {
  echo "[Remote Install] ${1}"
}

function clone_git_repo() {
  echo_ri "Cloning dotfiles repo..."
  git clone git@github.com:ChrisCarini/dotfiles.git ~/dotfiles
}

function download_repo_as_tarball() {
  echo_ri "Checking for available commands to download tarball..."
  if [[ -x "$(command -v curl)" ]]; then
    CMD="curl -#L"
  elif [[ -x "$(command -v wget)" ]]; then
    CMD="wget --no-check-certificate -O -"
  fi

  if [[ -z "$CMD" ]]; then
    echo_ri "No curl or wget available. Aborting."
    exit 126
  fi

  echo_ri "Making dotfiles directory..."
  mkdir -p "$HOME/dotfiles"

  echo_ri "Downloading dotfiles..."
  eval "$CMD https://github.com/ChrisCarini/dotfiles/tarball/master | tar -xzv -C ~/dotfiles --strip-components=1 --exclude='{.gitignore}'"
  echo_ri "##############################################################################"
  echo_ri "##     __          __           _____    _   _   _____   _   _    _____     ##"
  echo_ri "##     \ \        / /   /\     |  __ \  | \ | | |_   _| | \ | |  / ____|    ##"
  echo_ri "##      \ \  /\  / /   /  \    | |__) | |  \| |   | |   |  \| | | |  __     ##"
  echo_ri "##       \ \/  \/ /   / /\ \   |  _  /  | . ` |   | |   | . ` | | | |_ |    ##"
  echo_ri "##        \  /\  /   / ____ \  | | \ \  | |\  |  _| |_  | |\  | | |__| |    ##"
  echo_ri "##         \/  \/   /_/    \_\ |_|  \_\ |_| \_| |_____| |_| \_|  \_____|    ##"
  echo_ri "##                                                                          ##"
  echo_ri "##############################################################################"
  echo_ri "##                                                                          ##"
  echo_ri "##                     ~/dotfiles is not managed by git                     ##"
  echo_ri "##                                                                          ##"
  echo_ri "##############################################################################"
  sleep 5
}

if [[ -x "$(command -v git)" ]]; then
  clone_git_repo
else
  download_repo_as_tarball
fi

echo_ri "Invoking installation script..."
. ~/dotfiles/install.sh

echo_ri "Installation Complete."
exit 0

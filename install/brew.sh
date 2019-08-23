#!/usr/bin/env bash
if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

# We need to chown the Cellar directory otherwise brew will complain a lot during the installs below.
sudo chown -R $(whoami) /usr/local/Cellar

brew update
brew upgrade

apps=(
  bash-completion
  brew-cask-completion
  coreutils
  docker
  docker-compose
  dockutil
  gcc
  git
  git-extras
  hyperfine
  imagemagick
  jq
  libcouchbase
  mosh
  mysql
  nano
  packer
  ssh-copy-id
  tree
  unar
  watch
  wget
)

brew install "${apps[@]}"


##
# Special stuff for MySQL + Python
# To prevent the below error:
#       fatal error: 'my_config.h' file not found
#
# See: https://stackoverflow.com/questions/12218229/my-config-h-file-not-found-when-intall-mysql-python-on-osx-10-8
#  for details.
brew unlink mysql
brew install mysql-connector-c
brew link --overwrite mysql

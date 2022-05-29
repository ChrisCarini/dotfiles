#!/usr/bin/env bash
if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

# Install Brew
# Note: We pipe echo, because brew installation will prompt the user to hit the [enter] key.
echo | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

# We need to chown the Cellar directory otherwise brew will complain a lot during the installs below.
sudo chown -R $(whoami) /usr/local/Cellar

# We need to chown /usr/local (the brew default prefix), among other suggested fixes by `brew doctor`
sudo chown -R $(whoami) $(brew --prefix)/*
sudo chown -R $(whoami) $(brew --prefix)/var/log
sudo chown -R $(whoami) $(brew --cache)
chmod u+w $(brew --prefix)/var/log

brew update
brew upgrade

# Tap for `displayplacer`
brew tap jakehilborn/jakehilborn

apps=(
  bash-completion
  brew-cask-completion
  coreutils
  #  docker          # This is installed as part of `brew-cask.sh` `docker` installation
  #  docker-compose  # This is installed as part of `brew-cask.sh` `docker` installation
  #  docker-completion          # This causes failure due to completion already being installed.
  #  docker-compose-completion  # This causes failure due to completion already being installed.
  #  docker-machine-completion  # This causes failure due to completion already being installed.
  dockutil
  displayplacer # `brew tap jakehilborn/jakehilborn` is the tap run above in order to make this a
  gcc
  # GitHub CLI
  gh
  git
  git-extras
  gource
  gpg
  gping # https://github.com/orf/gping
  hyperfine
  imagemagick
  jless
  jq
  libcouchbase
  mosh
  mysql
  #  mysql@5.7  # needed for work
  nano
  nmap
  p7zip
  packer
  pv
  ssh-copy-id
  telnet
  tree
  unar
  watch
  wget
)

function is_in_list() {
  if [[ $2 =~ (^|[[:space:]])$1($|[[:space:]]) ]]; then
    return 0
  else
    return 1
  fi
}

# Get the list of currently installed brew applications
INSTALLED_BREW_APPS=$(brew list)

for APPLICATION in "${apps[@]}"; do
  # Check if the application is already installed
  if is_in_list "$APPLICATION" "$INSTALLED_BREW_APPS"; then
    echo "The package [$APPLICATION] is installed. Skipping."
  else
    echo "The package [$APPLICATION] is NOT installed. Installing $APPLICATION ..."
    # Call brew with the envvar to disable auto-update.
    HOMEBREW_NO_AUTO_UPDATE=1 brew install "$APPLICATION"
  fi
done

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

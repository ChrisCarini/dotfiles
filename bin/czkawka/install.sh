#!/bin/bash

pushd ~/dotfiles/bin/czkawka/ || exit

echo "Installing necessary brew packages, if not found..."
BREW_PACKAGES="gtk+3 adwaita-icon-theme ffmpeg librsvg"
# shellcheck disable=SC2086
brew list $BREW_PACKAGES &>/dev/null || brew install $BREW_PACKAGES

echo "Determining latest version of czkawka..."
LATEST_VERSION=$(curl --silent "https://api.github.com/repos/qarmin/czkawka/releases/latest" | jq -r .tag_name)

if [[ ! -f "mac_czkawka_cli-${LATEST_VERSION}" ]]; then
  echo "Downloading [mac_czkawka_cli-${LATEST_VERSION}]..."
  wget -q --show-progress -O "mac_czkawka_cli-${LATEST_VERSION}" https://github.com/qarmin/czkawka/releases/latest/download/mac_czkawka_cli
fi
if [[ ! -f "mac_czkawka_gui-${LATEST_VERSION}" ]]; then
  echo "Downloading [mac_czkawka_gui-${LATEST_VERSION}]..."
  wget -q --show-progress -O "mac_czkawka_gui-${LATEST_VERSION}" https://github.com/qarmin/czkawka/releases/latest/download/mac_czkawka_gui
fi

echo "${LATEST_VERSION}" >LATEST_VERSION

if [[ ! -L mac_czkawka_cli ]]; then
  echo "Linking mac_czkawka_cli..."
  ln -s "./mac_czkawka_cli-${LATEST_VERSION}" mac_czkawka_cli
fi
if [[ ! -L mac_czkawka_gui ]]; then
  echo "Linking mac_czkawka_gui..."
  ln -s "./mac_czkawka_gui-${LATEST_VERSION}" mac_czkawka_gui
fi

echo "Changing permissions to be executable..."
chmod u+x "mac_czkawka_cli-${LATEST_VERSION}"
chmod u+x "mac_czkawka_gui-${LATEST_VERSION}"

# shellcheck disable=SC2164
popd

echo "Done."

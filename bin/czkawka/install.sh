#!/bin/bash

pushd ~/dotfiles/bin/czkawka/ || exit

echo "Installing necessary brew packages, if not found..."
BREW_PACKAGES="gtk4 adwaita-icon-theme ffmpeg librsvg libheif pkg-config"
# shellcheck disable=SC2086
brew list $BREW_PACKAGES &>/dev/null || brew install $BREW_PACKAGES


binaries=(
  "czkawka_gui"
  "czkawka_cli"
  "krokiet"
)

arch=$(uname -m)
if [ "$arch" == "arm64" ]; then
  echo "==== The system is running on arm64 architecture. Cloning GitHub repo and building manually... ===="
  git clone https://github.com/qarmin/czkawka.git
  pushd czkawka

  echo "Determining latest version of czkawka..."
  LATEST_VERSION=$(cat czkawka_gui/Cargo.toml | \grep '^version = ' | cut -d ' ' -f 3 | xargs)
  echo "${LATEST_VERSION}" >../LATEST_VERSION

  for binary in "${binaries[@]}"; do
    echo "Building binary: ${binary}"
    cargo build --quiet --release --bin "${binary}"
    cp "target/release/${binary}" "../${binary}-${LATEST_VERSION}"
  done
  popd
  rm -rf ./czkawka
else
  echo "==== The system is not running on arm64 architecture. Downloading czkawka builds from GitHub... ===="

  echo "Determining latest version of czkawka..."
  LATEST_VERSION=$(curl --silent "https://api.github.com/repos/qarmin/czkawka/releases/latest" | jq -r .tag_name)
  echo "${LATEST_VERSION}" >LATEST_VERSION

  for binary in "${binaries[@]}"; do
    if [[ ! -f "${binary}-${LATEST_VERSION}" ]]; then
      echo "Downloading [${binary}-${LATEST_VERSION}]..."
      wget -q --show-progress -O "${binary}-${LATEST_VERSION}" "https://github.com/qarmin/czkawka/releases/latest/download/mac_${binary}"
    fi
  done
fi

for binary in "${binaries[@]}"; do
  if [[ ! -L ${binary} ]]; then
    echo "Linking ${binary}..."
    ln -s "./${binary}-${LATEST_VERSION}" "${binary}"
  fi

  echo "Changing permissions to be executable..."
  chmod u+x "./${binary}-${LATEST_VERSION}"
done

# shellcheck disable=SC2164
popd

echo "Done."

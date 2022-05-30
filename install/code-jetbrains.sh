#!/usr/bin/env bash

# Install personal JetBrains code repositories

# We need to source the functions in order to get access to `git-config-repo-github`
source ~/dotfiles/system/.functions

BASE_CODE_PATH=${1:-~/GitHub}
BASE_JB_CODE_PATH="${BASE_CODE_PATH}/jetbrains"
BASE_JB_PLUGINS_CODE_PATH="${BASE_JB_CODE_PATH}/plugins"

# Create a directory structure for our JetBrains tepos.
mkdir -p "${BASE_JB_PLUGINS_CODE_PATH}"

##
# Checkout JetBrains Plugin Repos
##
jetbrains_plugin_repos=(
  ChrisCarini/environment-variable-settings-summary-intellij-plugin
  ChrisCarini/intellij-code-exfiltration
  ChrisCarini/intellij-notification-sample
  ChrisCarini/iris-jetbrains-plugin
  ChrisCarini/jetbrains-auto-power-saver
  ChrisCarini/loc-change-count-detector-jetbrains-plugin
  ChrisCarini/logshipper-intellij-plugin
  ChrisCarini/sample-intellij-plugin
)
pushd "${BASE_JB_PLUGINS_CODE_PATH}"
for REPO in "${jetbrains_plugin_repos[@]}"; do
  CODE_REPO_PATH="${BASE_JB_PLUGINS_CODE_PATH}/$(echo ${REPO} | cut -d'/' -f2)"
  # Check if the directory already exists
  if [ -d "$CODE_REPO_PATH" ]; then
    echo "$CODE_REPO_PATH already exists, skipping..."
    continue
  fi
  echo "Cloning ${REPO}..."
  git clone "git@github.com:${REPO}.git"
  echo "[Done] Cloning ${REPO}."
  echo # Newline makes the output nicer to read.
done
popd

##
# Checkout Misc JetBrains Repos
##
jetbrains_misc_repos=(
#  ChrisCarini/intellij-community # 2021-10-15 - ChrisCarini - Commenting out, because I do not currently have / need a fork of IC.
  ChrisCarini/intellij-platform-plugin-verifier-action
  ChrisCarini/jetbrains-ide-release-dates
  ChrisCarini/jetbrains-plugin-scripts
  ChrisCarini/jetbrains.chriscarini.com
)
pushd "${BASE_JB_CODE_PATH}"
for REPO in "${jetbrains_misc_repos[@]}"; do
  CODE_REPO_PATH="${BASE_JB_CODE_PATH}/$(echo ${REPO} | cut -d'/' -f2)"
  # Check if the directory already exists
  if [ -d "$CODE_REPO_PATH" ]; then
    echo "$CODE_REPO_PATH already exists, skipping..."
    continue
  fi
  echo "Cloning ${REPO}..."
  git clone "git@github.com:${REPO}.git"
  echo "[Done] Cloning ${REPO}."
  echo # Newline makes the output nicer to read.
done

if [ -d "${BASE_JB_CODE_PATH}/intellij-community/" ]; then
  # We also want to set the correct upstream for `intellij-community` repo.
  echo "Adding upstream and sync local 'intellij-community' with upstream..."
  cd "${BASE_JB_CODE_PATH}/intellij-community/"
  echo "Remote Before:"
  git remote -v
  git remote add upstream https://github.com/JetBrains/intellij-community.git
  echo "Remote After:"
  git remote -v
  git fetch upstream
  git checkout master
  git merge upstream/master
  echo "[Done] Sync local 'intellij-community' with upstream."
fi

# Clone JetBrains IntelliJ Community repo
# NOTE: Making use of blobless clones: https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/#user-content-blobless-clones
git clone --filter=blob:none https://github.com/JetBrains/intellij-community.git JB_intellij-community

popd

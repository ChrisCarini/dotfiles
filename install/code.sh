#!/usr/bin/env bash

# Install personal code repositories


# We need to source the functions in order to get access to `git-config-repo-github`
source ~/dotfiles/system/.functions

BASE_CODE_PATH=~/GitHub

cd ${BASE_CODE_PATH}

repos=(
    ChrisCarini/logshipper-intellij-plugin
    ChrisCarini/environment-variable-settings-summary-intellij-plugin
    ChrisCarini/intellij-notification-sample
    ChrisCarini/intellij-code-exfiltration
    ChrisCarini/jetbrains-ide-release-dates
    ChrisCarini/jetbrains-auto-power-saver
    ChrisCarini/iris-jetbrains-plugin
    ChrisCarini/sample-python-profile-flask
    ChrisCarini/sample-intellij-plugin
    ChrisCarini/intellij-community
    ChrisCarini/skypi
)

for REPO in "${repos[@]}"; do
    # Check if the application is installed with `brew cask`
    echo "Cloning ${REPO}..."
    git clone git@github.com:${REPO}.git
    cd ${BASE_CODE_PATH}/$(echo ${REPO} | cut -d'/' -f2)
    git-config-repo-github
    cd ${BASE_CODE_PATH}
    echo "[Done] Cloning ${REPO}."
done


echo "Adding upstream and sync local 'intellij-community' with upstream..."
cd ${BASE_CODE_PATH}/intellij-community/
echo "Remote Before:"
git remote -v
git remote add upstream https://github.com/JetBrains/intellij-community.git
echo "Remote After:"
git remote -v
git fetch upstream
git checkout master
git merge upstream/master
echo "[Done] Sync local 'intellij-community' with upstream."
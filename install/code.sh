#!/usr/bin/env bash

# Install personal code repositories


# We need to source the functions in order to get access to `git-config-repo-github`
source ~/dotfiles/system/.functions

BASE_CODE_PATH=~/GitHub

cd ${BASE_CODE_PATH}

repos=(
# a
# b
# c
    ChrisCarini/crypto-to-influxdb
# d
# e
    ChrisCarini/environment-variable-settings-summary-intellij-plugin
# f
# g
    ChrisCarini/google-apps-scripts
# h
    ChrisCarini/homelab-infra-configs
# i
    ChrisCarini/intellij-code-exfiltration
    ChrisCarini/intellij-community
    ChrisCarini/intellij-notification-sample
    ChrisCarini/intellij-platform-plugin-verifier-action
    ChrisCarini/iris-jetbrains-plugin
# j
    ChrisCarini/jetbrains-auto-power-saver
    ChrisCarini/jetbrains-ide-release-dates
    ChrisCarini/jetbrains.chriscarini.com
    ChrisCarini/jupyter-docker
# k
# l
    ChrisCarini/logshipper-intellij-plugin
# m
    manojVivek/medium-unlimited
# n
# o
    ChrisCarini/organizedPhotos
# p
# q
# r
# s
    ChrisCarini/sample-intellij-plugin
    ChrisCarini/sample-load-test-apache-jmeter
    ChrisCarini/sample-python-profile-flask
    ChrisCarini/speedtest-to-gsheet
    ChrisCarini/skypi
# t
# u
    ChrisCarini/upptime
# v
# w
# x
# y
# z
)

for REPO in "${repos[@]}"; do
    CODE_REPO_PATH="${BASE_CODE_PATH}/$(echo ${REPO} | cut -d'/' -f2)"
    # Check if the directory already exists
    if [ -d "$CODE_REPO_PATH" ]; then
        echo "$CODE_REPO_PATH already exists, skipping..."
        continue
    fi
    echo "Cloning ${REPO}..."
    git clone git@github.com:${REPO}.git
    cd "$CODE_REPO_PATH"
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
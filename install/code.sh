#!/usr/bin/env bash

# Install personal code repositories


# We need to source the functions in order to get access to `git-config-repo-github`
source ~/dotfiles/system/.functions

BASE_CODE_PATH=~/GitHub

cd ${BASE_CODE_PATH}

repos=(
# a
    ChrisCarini/adventofcode
# b
# c
    ChrisCarini/chriscarini.com
    ChrisCarini/crypto-to-influxdb
    mnagel/clustergit
# d
# e
# f
# g
    ChrisCarini/google-apps-scripts
# h
    ChrisCarini/homelab-infra-configs
# i
# j
    ChrisCarini/jupyter-docker
# k
# l
# m
    manojVivek/medium-unlimited
# n
# o
    ChrisCarini/organizedPhotos
# p
# q
# r
# s
    ChrisCarini/sample-load-test-apache-jmeter
    ChrisCarini/sample-python-profile-flask
    ChrisCarini/shodan-exposure-box
    ChrisCarini/skypi
    ChrisCarini/speedtest-to-gsheet
# t
    ChrisCarini/treasury-direct-password-enable-user-script
    ChrisCarini/trivia-box
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
    git clone "git@github.com:${REPO}.git"
    echo "[Done] Cloning ${REPO}."
done

~/dotfiles/macos/finder_favorites.sh "${BASE_CODE_PATH}"
#!/bin/bash
# Check if the configuration file exists in either location.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
if test -e "${SCRIPT_DIR}/rclone.conf"; then
  CONFIG="${SCRIPT_DIR}/rclone.conf"
elif test -e ~/.config/rclone/rclone.conf; then
  CONFIG=~/.config/rclone/rclone.conf
else
  echo "###############################################"
  echo "##     _____  ____   ____    ___   ____      ##"
  echo "##    | ____||  _ \ |  _ \  / _ \ |  _ \     ##"
  echo "##    |  _|  | |_) || |_) || | | || |_) |    ##"
  echo "##    | |___ |  _ < |  _ < | |_| ||  _ <     ##"
  echo "##    |_____||_| \_\|_| \_\ \___/ |_| \_\    ##"
  echo "##                                           ##"
  echo "###############################################"
  echo "##"
  echo "##  This script expects a configuration file to exist. Two options below:"
  echo "##      - './rclone.conf' (config file in same dir as this script)"
  echo "##      - '~/.config/rclone/rclone.conf' (hidden config file in home directory)"
  echo "##"
  echo "##  The config file should have the below contents:"
  echo "##"
  echo "##      [rackstation]"
  echo "##      type = smb"
  echo "##      host = <hostname>"
  echo "##      pass = <password>"
  echo "##"
  echo "##  These parameters are used as below when connecting:"
  echo "##"
  echo "##    rclone --config="\$\{CONFIG\}" sync ... \$dir_to_backup rackstation:<share>"
  echo "##"
  echo "###############################################"
  exit 1
fi

echo "##########################################"
echo "##                                      ##"
echo "##    Using the below configuration     ##"
echo "##                                      ##"
echo "##########################################"
echo "##"
echo "##      CONFIG=${CONFIG}"
echo "#/"
echo "/"

# Check is Lock File exists, if not create it and set trap on exit
if ! ( set -o noclobber ; echo > ~/backup_to_nas_full_user.lock); then
  echo "Lock file exists... exiting without backup."
  exit 1
fi

echo 'Lockfile created successfully, backing up...'
trap "echo 'Exiting successfully, cleaning up lock file...' ; rm -f ~/backup_to_nas_full_user.lock" EXIT

##
# Mirror to storage and back
##
dir=~/
echo "======================================="
echo "BACKING UP: ${dir}"
echo "======================================="

echo "---------------------------"
echo "Push This machine -> Remote"
echo "---------------------------"
rclone --config="${CONFIG}" \
      sync \
      --progress \
      --skip-links \
      --smb-user=shiba \
      --transfers=8 \
      --checkers=64 \
      --ignore-errors \
      --retries-sleep=500ms \
      --stats-file-name-length=0 \
      --exclude="*.sock" \
      --exclude="*/build/" \
      --exclude="*/config/external/" \
      --exclude="*/node_modules/" \
      --exclude="*/site-packages/" \
      --exclude="*/venv/" \
      --exclude="*@eaDir/" \
      --exclude=".DS_Store" \
      --exclude=".android/" \
      --exclude=".bash_sessions/" \
      --exclude=".bw/" \
      --exclude=".cache/" \
      --exclude=".cargo/" \
      --exclude=".config/github-copilot/" \
      --exclude=".docker/" \
      --exclude=".gem/" \
      --exclude=".gnupg/S.*" \
      --exclude=".gradle/" \
      --exclude=".ivy2/" \
      --exclude=".local/" \
      --exclude=".m2/" \
      --exclude=".midgard/" \
      --exclude=".mypy_cache/" \
      --exclude=".npm/" \
      --exclude=".ollama/" \
      --exclude=".rustup/" \
      --exclude=".shiv/" \
      --exclude=".ssh/cm-gh-*" \
      --exclude=".volta/" \
      --exclude=".yarn/" \
      --exclude="IdeaProjects/" \
      --exclude="Library/Application Support/" \
      --exclude="Library/Biome/" \
      --exclude="Library/Caches/" \
      --exclude="Library/Containers/" \
      --exclude="Library/Group Containers/" \
      --exclude="Library/Java/" \
      --exclude="Library/Logs/" \
      --exclude="Library/Metadata/CoreSpotlight/" \
      --exclude="Library/Preferences/" \
      --exclude="fsmonitor--daemon.ipc" \
      --exclude="go/" \
      --exclude="local-repo/" \
      --exclude="miniconda3/" \
      --exclude="tmp/" \
      --exclude="wifi_rssi.csv" \
      "${dir}" rackstation:Important_Backups/2_way_sync_${HOSTNAME}_full_user_dir
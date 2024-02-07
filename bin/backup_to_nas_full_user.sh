#!/bin/bash
# Check if the configuration file exists in either location.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $SCRIPT_DIR
if test -e "$SCRIPT_DIR/backup_to_nas.config"; then
  source "$SCRIPT_DIR/backup_to_nas.config"
elif test -e ~/.backup_to_nas.config; then
  source ~/.backup_to_nas.config
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
  echo "##      - './backup_to_nas.config' (config file in same dir as this script)"
  echo "##      - '~/.backup_to_nas.config' (hidden config file in home directory)"
  echo "##"
  echo "##  The config file should have the below contents:"
  echo "##"
  echo "##      REMOTE_USERNAME=<username>"
  echo "##      REMOTE_HOSTNAME=<hostname>"
  echo "##      REMOTE_PATHNAME=<pathname>"
  echo "##"
  echo "##  These parameters are used as below when connecting:"
  echo "##"
  echo "##    rsync \$REMOTE_USERNAME@\$REMOTE_HOSTNAME:\$REMOTE_PATHNAME"
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
echo "##      REMOTE_USERNAME=$REMOTE_USERNAME"
echo "##      REMOTE_HOSTNAME=$REMOTE_HOSTNAME"
echo "##      REMOTE_PATHNAME=$REMOTE_PATHNAME"
echo "#/"
echo "/"

# Check is Lock File exists, if not create it and set trap on exit
if ! ( set -o noclobber ; echo > ~/backup_to_nas.lock); then
  echo "Lock file exists... exiting without backup."
  exit 1
fi

echo 'Lockfile created successfully, backing up...'
trap "echo 'Exiting successfully, cleaning up lock file...' ; rm -f ~/backup_to_nas.lock" EXIT

##
# Mirror to storage and back
##
dir=~/
echo "======================================="
echo "BACKING UP: ${dir}"
echo "======================================="
# Remote directory name; replace '/' with '_'
remote_dir_name=${dir//\//_}

#  # For Debugging..
#  echo "rsync -auvz --exclude=\"*@eaDir/\" --progress \"$dir/\" \"$REMOTE_USERNAME@$REMOTE_HOSTNAME:$REMOTE_PATHNAME/2_way_sync_$HOSTNAME/$remote_dir_name\""
#  echo "rsync -auvz --exclude=\"*@eaDir/\" --progress \"$REMOTE_USERNAME@$REMOTE_HOSTNAME:$REMOTE_PATHNAME/2_way_sync_$HOSTNAME/$remote_dir_name/\" \"$dir\""

echo "---------------------------"
echo "Push This machine -> Remote"
echo "---------------------------"
#      --list-only \
#      --info=progress2 \
#      --no-inc-recursive \
rsync -auvz \
      --progress \
      --exclude="*/build/" \
      --exclude="*/config/external/" \
      --exclude="*/node_modules/" \
      --exclude="*/site-packages/" \
      --exclude="*/venv/" \
      --exclude="*@eaDir/" \
      --exclude=".DS_Store" \
      --exclude=".bash_sessions/" \
      --exclude=".midguard/" \
      --exclude=".cache/" \
      --exclude=".cargo/" \
      --exclude=".docker/buildx/" \
      --exclude=".gem/" \
      --exclude=".gradle/" \
      --exclude=".m2/" \
      --exclude=".npm/" \
      --exclude=".rustup/" \
      --exclude=".shiv/" \
      --exclude=".volta/" \
      --exclude="Library/Group Containers/group.com.apple.secure-control-center-preferences/" \
      --exclude="Library/Caches/Google/Chrome/**/Cache/Cache_Data/" \
      --exclude="Library/Application Support/Google/Chrome/component_crx_cache/" \
      --exclude="Library/Preferences/.GlobalPreferences_m.plist" \
      --exclude="Library/Caches/JetBrains/**/caches/" \
      --exclude="Library/Caches/JetBrains/**/index/" \
      --exclude="Library/Caches/JetBrains/**/jcef_cache/" \
      --exclude="Library/Caches/JetBrains/**/tmp/" \
      --exclude="Library/Containers/com.docker.docker/Data/vms/" \
      --exclude="Library/Application Support/JetBrains/**/system/index/" \
      --delete-excluded \
      "$dir/" "$REMOTE_USERNAME@$REMOTE_HOSTNAME:$REMOTE_PATHNAME/2_way_sync_${HOSTNAME}_full_user_dir/$remote_dir_name"
#echo "---------------------------"
#echo "Push Remote -> This machine"
#echo "---------------------------"
#rsync -auvz \
#      --progress \
#      --list-only \
#      --exclude=".DS_Store" \
#      --exclude="*@eaDir/" \
#      --exclude="*/build/" \
#      --exclude="*/node_modules/" \
#      --exclude="*/venv/" \
#      "$REMOTE_USERNAME@$REMOTE_HOSTNAME:$REMOTE_PATHNAME/2_way_sync_${HOSTNAME}_full_user_dir/$remote_dir_name/" "$dir"

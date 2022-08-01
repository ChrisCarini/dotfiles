#!/bin/bash

# TAKEN FROM: https://www.reddit.com/r/mac/comments/c8wacm/comment/esrvj6d/
# Modified because there were too many sleep statements between prints.

echo 'This script forces the macOS to purge any purge-able files.'
echo 'You can see the purge-able space by clicking "Get Info" on the main hard drive.'
echo
echo '[Notice] This could take a few minutes, depending on the speed of your disk.'
echo
echo 'Save any open documents and quit running applications now.'
echo
read -n1 -s -r -p $'Press [Enter] to continue...\n' key
if [ "$key" != '' ]; then
  # Anything else pressed, do whatever else.
  # echo [$key] not empty
  echo 'Did not press enter. Exiting...'
  exit 1
fi

echo -e 'Once your disk is nearly full, you might see the following dialog box:'
echo -e '\t\"Your Disk space is critically low.\"'
echo
echo 'This is normal.'
echo

startspace=$(($(df -m / | awk 'int($4){print $4}') * 1024 * 1024 / 1000000000))
echo "You currently have ${startspace} GB of available space."

echo 'Creating temporary files ["ClearPurgeableSpace" dir, 4G, 500MB & 100MB files] on desktop...'
mkdir -p ~/Desktop/ClearPurgeableSpace
mkfile 4G ~/Desktop/ClearPurgeableSpace/largefile4G
mkfile 500M ~/Desktop/ClearPurgeableSpace/largefile500M
mkfile 100M ~/Desktop/ClearPurgeableSpace/largefile100M
echo 'Done'

echo 'Now filling up available space... '
diskspace=$(($(df -m / | awk 'int($4){print $4}') * 1024 * 1024 / 1000000))
diskspace_new=0
while [ 0 ]; do

  if [ $diskspace_new -gt $diskspace ]; then
    echo 'Approx '$(($diskspace_new - $diskspace))' MB of purgeable space was just cleared! Continuing...'
  fi

  diskspace=$(($(df -m / | awk 'int($4){print $4}') * 1024 * 1024 / 1000000))
  echo "${diskspace} MB remaining, please wait..."

  if [ 8000 -lt $diskspace ]; then
    cp ~/Desktop/ClearPurgeableSpace/largefile4G{,"$(date)"} && sleep 1 && waiting=0
  elif [ 2000 -lt $diskspace ]; then
    cp ~/Desktop/ClearPurgeableSpace/largefile500M{,"$(date)"} && sleep 1 && waiting=0
  elif [ 800 -lt $diskspace ]; then
    cp ~/Desktop/ClearPurgeableSpace/largefile100M{,"$(date)"} && sleep 1 && waiting=0
  elif [ 500 -lt $diskspace ]; then
    cp ~/Desktop/ClearPurgeableSpace/largefile100M{,"$(date)"} && sleep 1 && waiting=1
  elif [ $waiting -eq 1 ]; then
    echo 'Pausing for 5 seconds to give OS time to purge, please wait...' && sleep 5 && waiting=2
  elif [ $waiting -eq 2 ]; then
    echo 'Pausing for 10 seconds to give OS time to purge, please wait...' && sleep 10 && waiting=3
  elif [ $waiting -eq 3 ]; then
    echo 'Pausing for 15 seconds to give OS time to purge, please wait...' && sleep 15 && waiting=4
  else
    break
  fi

  diskspace_new=$(($(df -m / | awk 'int($4){print $4}') * 1024 * 1024 / 1000000))

done

echo -e 'Purging complete. Clearing temporary files...'
rm -R ~/Desktop/ClearPurgeableSpace
echo 'All done! Your disk space has been reclaimed.'

endspace=$(($(df -m / | awk 'int($4){print $4}') * 1024 * 1024 / 1000000000))
echo 'You just recovered '$(($endspace - $startspace))' GB!'
echo 'You now have '$endspace' GB of free space.'

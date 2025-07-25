#!/usr/bin/env bash
####################################################
# Get current dir (so run this script from anywhere)
####################################################
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"

##########################
# Make utilities available
##########################
PATH="$DOTFILES_DIR/bin:$PATH"

#################################################################
# For adding $USER to /etc/sudoers for duration of install script
#################################################################
USER_SUDOER="${USER} ALL=(ALL) NOPASSWD: ALL"
TMP_SUDOERS_D_FILE=/etc/sudoers.d/ChrisCarini_dotfiles_install_sh_script

#############################
# Setup the cleanup functions
#############################
# Below, we will add the user to the sudoers file - this will revert that upon exit
function reset_sudoers() {
  echo 'Resetting /etc/sudoers.d ...'
  /usr/bin/sudo rm "${TMP_SUDOERS_D_FILE}"
}

# The main method for script finalization
function finalize_script() {
  reset_sudoers

  # Set the post-install.sh flag since we've completed successfully.
  POST_INSTALL_FLAG_FILE=~/dotfiles/.post-install.sh.flag
  touch "$POST_INSTALL_FLAG_FILE"

  echo "#####################################"
  echo "##                                 ##"
  echo "##  SCRIPT COMPLETED SUCCESSFULLY  ##"
  echo "##                                 ##"
  echo "#####################################"
  echo
  echo "Logging the user out in 30 seconds to allow for the setting changes to take effect."
  echo
  echo -e "Hold \033[1;39mSPACE\033[0m/\033[1;39mENTER\033[0m speed up logging out. Press any other key to abort logout."
  echo
  for i in {01..30}; do
    printf "\r %s of 30 seconds until logout..." "${i}"
    # In the following line -t for timeout, -N for just 1 character
    read -s -r -t 1 -n 1 input # wait 1 sec for 1 char of user input; suppress input on screen
    if [ "$input" != '' ]; then
      echo
      echo "Aborting logout..."
      echo
      echo -e "$(tput setaf 1)WARNING: Ensure you log out to have all configuration changes take effect and post-installation to complete.$(tput sgr0)\033[m"
      echo
      exit 1
    fi
  done

  # Forcefully log out the user.
  launchctl bootout gui/$(id -u $USER)
}

# Trap the `EXIT` signal and run our cleanup scripts
trap finalize_script EXIT

#######################################################################
title "Elevate privileges to avoid prompts throughout the installation"
#######################################################################
# Ask for the administrator password upfront, and add $USER to /etc/sudoers for the duration of the script.
#
# Note: The previous method of creating a background loop to persist the sudo timestamp
#       won't work because `brew` explicitly invalidates the sudo timestamp. Adding the
#       user to the sudoers file is the most reliable way I've found.
#
#       See https://gist.github.com/cowboy/3118588#gistcomment-2016660 for others report of this.
echo "Prompting for sudo password..."
sudo --validate || exit 1

echo "${USER_SUDOER}" | /usr/bin/sudo -E -- /usr/bin/tee -a "${TMP_SUDOERS_D_FILE}" >/dev/null
/usr/bin/sudo chmod 644 "${TMP_SUDOERS_D_FILE}"

########################################
title "Ensure shell is set to /bin/bash"
########################################
if [[ "$SHELL" != "/bin/bash" ]]; then
  echo "Default shell for $USER is $SHELL and NOT /bin/bash, changing to /bin/bash..."
  sudo chsh -s /bin/bash $USER
else
  echo "Default shell for $USER is $SHELL, proceeding..."
fi

########################################################
title "Copy ~/.ssh directory over from previous machine"
########################################################
# If ~/.ssh exists and is not empty, assume we copied over the SSH directory earlier.
if [[ -d ~/.ssh ]] && [[ -n "$(ls -A ~/.ssh)" ]]; then
  echo "[INFO] ~/.ssh directory already exists and has contents, assuming it was copied earlier."
else
  echo "[INFO] Nothing exists in ~/.ssh directory. Prompt for previous hostname..."

  if [[ -z ${PREVIOUS_HOSTNAME+x} ]]; then
    # We need to redirect input from /dev/tty because we pipe this script into `sh` when invoking.
    read -p "Enter previous machine hostname (for SSH directory copy): " PREVIOUS_HOSTNAME </dev/tty
  else
    echo "Previous machine hostname already set to: $PREVIOUS_HOSTNAME"
  fi

  echo "[INFO] Copying from $PREVIOUS_HOSTNAME..."
  if [[ -z ${PREVIOUS_HOSTNAME+x} ]]; then
    echo "WARNING: No hostname set; skipping copying SSH directory from previous machine."
  else
    scp -r $PREVIOUS_HOSTNAME:~/.ssh ~/
  fi
fi

###################################
title "Gather all inputs from user"
###################################
if [[ ! -e ~/dotfiles/work_dotfiles_location ]]; then
  # We need to redirect input from /dev/tty because we pipe this script into `sh` when invoking.
  read -p "Enter work dotfiles git repo: " WORK_DOTFILES_REPO_URL </dev/tty
else
  WORK_DOTFILES_REPO_URL=$(cat ~/dotfiles/work_dotfiles_location)
fi

if is-macos; then
  ####################################################################
  title "Preventing system from sleeping for duration of installation"
  ####################################################################
  /usr/bin/caffeinate -dimu -w $$ &
  echo "Display, System, & Disk will remain awake for duration of this process (PID: $$)."
fi

if is-macos; then
  ######################################################################################
  title "Grant '/Application/Utilities/Terminal.app' the 'Full Disk Access' permission."
  ######################################################################################
  # NOTES:
  #   - Preference Panes can be found here: /System/Library/PreferencePanes/Security.prefPane
  #   - https://github.com/bvanpeski/SystemPreferences/blob/main/macos_preferencepanes-Ventura.md
  open "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles"

  read -n 1 -s -r -p "Press any key when permission has been granted."
fi

# TODO(ChrisCarini) - Move this out of personal dotfiles, and into a script that's pulled before `git clone` is run below.
#  NOTE: This can't be in work dotfiles, because this is needed in order to `git clone` from work.
if is-macos; then
  ###################################
  title "Configure ssh config files."
  ###################################
  echo "Run the below command(s) to configure:"
  echo
  echo "  - brewin engtools install lnkd-manage-ssh"
  echo "  - sudo /usr/local/linkedin/bin/manage-ssh --force"

  read -n 1 -s -r -p "Press any key when run and completed."
fi

##############################
title "Checkout work dotfiles"
##############################
if [ -z $WORK_DOTFILES_REPO_URL ]; then
  echo "WARNING: No work dotfiles repo url set; skipping cloning work dotfiles directory."
else
  echo "Cloning ${WORK_DOTFILES_REPO_URL} into [~/dotfiles/work]..."
  git clone $WORK_DOTFILES_REPO_URL ~/dotfiles/work
fi

if is-macos; then
  ##############################################
  title "Updating Software and Installing XCode"
  ##############################################
  sudo softwareupdate --install --all && xcode-select --install
fi

##
# Update dotfiles itself first
##
# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

#############################
title "Symlink core dotfiles"
#############################
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.bashrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}; do
  [[ -f "$DOTFILE" ]] && ln -sfv "$DOTFILE" ~
done

# Install work applications, should any exist. Do this before installing IntelliJ plugins, as the apps need to exist first.
if [[ -f "$DOTFILES_DIR/work/install/apps.sh" ]]; then
  ###########################################
  title "Install work applications"
  ###########################################
  . "$DOTFILES_DIR/work/install/apps.sh"
else
  echo "No [$DOTFILES_DIR/work/install/apps.sh] exists; not bootstrapping work applications!"
fi

if is-macos; then
  ############################################
  title "Installing brew, packages, and casks"
  ############################################
  . "$DOTFILES_DIR/install/brew.sh"

  # Configure pinentry for gpg - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key
  echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
  killall gpg-agent

  . "$DOTFILES_DIR/install/brew-cask.sh"
  . "$DOTFILES_DIR/install/hammerspoon.sh"
  . "$DOTFILES_DIR/install/intellij-plugins.sh"
  if [[ -f "$DOTFILES_DIR/work/install/intellij-plugins.sh" ]]; then
    . "$DOTFILES_DIR/work/install/intellij-plugins.sh"
  fi
  . "$DOTFILES_DIR/install/misc.sh"
fi

##########################
title "Create directories"
##########################
mkdir ~/code
mkdir ~/tmp
mkdir ~/GitHub
mkdir ~/Desktop/~DELETE\ THIS\ STUFF
mkdir ~/Desktop/Archive
mkdir ~/Desktop/Screen\ Shots\ To\ Save

############################
title "Checkout source code"
############################
. "$DOTFILES_DIR/install/code.sh"
# Run work code bootstrap, should it exist
if [[ -f "$DOTFILES_DIR/work/install/code.sh" ]]; then
  . "$DOTFILES_DIR/work/install/code.sh"
else
  echo "No work/install/code.sh exists; not bootstrapping work code!"
fi

##
# If OSX, let's do the dock + settings
##
if is-macos; then
  sudo "$DOTFILES_DIR/macos/settings.sh"
  sudo "$DOTFILES_DIR/macos/launchDaemons.sh"
  # Run dock.sh last, as the final step kills all items launched from the dock,
  # including the terminal the install.sh script is running from.
  . "$DOTFILES_DIR/macos/dock.sh"
fi

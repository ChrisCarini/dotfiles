#!/usr/bin/env bash
####################################################
# Get current dir (so run this script from anywhere)
####################################################
export DOTFILES_DIR DOTFILES_CACHE DOTFILES_EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"

#################
# Banner Function
#################
function title() {
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w < ${#l})) && {
      b="$l"
      w="${#l}"
    }
  done
  echo "####${b//?/#}####"
  for l in "${s[@]}"; do
    printf '#   %*s%s   #\n' "-$w" "$l"
  done
  echo "####${b//?/#}####"
}

#######################################################################
title "Elevate privileges to avoid prompts throughout the installation"
#######################################################################
# Ask for the administrator password upfront, and add $USER to /etc/sudoers for the duration of the script.
#
# Note: The previous method of creating a background loop to persist the sudo timestamp
#       won't work because `brew` explicitly invalidates the sudo timestamp. Adding the
#       user to the sudoers file is the most reliable way I've found.
echo "Prompting for sudo password..."
sudo --validate || exit 1

# Add $USER to /etc/sudoers for duration of script
USER_SUDOER="${USER} ALL=(ALL) NOPASSWD: ALL"

reset_sudoers() {
  echo -b 'Resetting /etc/sudoers ...'
  /usr/bin/sudo -E -- /usr/bin/sed -i '' "/^${USER_SUDOER}/d" /etc/sudoers
}

trap reset_sudoers EXIT

echo "${USER_SUDOER}" | /usr/bin/sudo -E -- /usr/bin/tee -a /etc/sudoers >/dev/null

##########################
# Make utilities available
##########################
PATH="$DOTFILES_DIR/bin:$PATH"

########################################
title "Ensure shell is set to /bin/bash"
########################################
if [[ "$SHELL" != "/bin/bash" ]]; then
  echo "Default shell for $USER is $SHELL and NOT /bin/bash, changing to /bin/bash..."
  sudo chsh -s /bin/bash $USER
else
  echo "Default shell for $USER is $SHELL, proceeding..."
fi

###################################
title "Gather all inputs from user"
###################################
if [[ -z ${PREVIOUS_HOSTNAME+x} ]]; then
  read -p "Enter previous machine hostname (for SSH directory copy): " PREVIOUS_HOSTNAME
else
  echo "Previous machine hostname already set to: $PREVIOUS_HOSTNAME"
fi
read -p "Enter work dotfiles git repo: " WORK_DOTFILES_REPO_URL

if is-macos; then
  ####################################################################
  title "Preventing system from sleeping for duration of installation"
  ####################################################################
  /usr/bin/caffeinate -dimu -w $$ &
fi

########################################################
title "Copy ~/.ssh directory over from previous machine"
########################################################
if [[ -z ${PREVIOUS_HOSTNAME+x} ]]; then
  echo "WARNING: No hostname set; skipping copying SSH directory from previous machine."
else
  scp -r $PREVIOUS_HOSTNAME:~/.ssh ~/
fi

##############################
title "Checkout work dotfiles"
##############################
if [ -z $WORK_DOTFILES_REPO_URL ]; then
  echo "WARNING: No work dotfiles repo url set; skipping cloning work dotfiles directory."
else
  git clone $WORK_DOTFILES_REPO_URL ~/dotfiles/work
fi

if is-macos; then
  ##############################################
  title "Updating Software and Installing XCode"
  ##############################################
  sudo softwareupdate -i -a && xcode-select --install
fi

##
# Update dotfiles itself first
##
# if is-executable git -a -d "$DOTFILES_DIR/.git"; then git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master; fi

#############################
title "Symlink core dotfiles"
#############################
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.vimrc" ~
for DOTFILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}; do
    [[ -f "$DOTFILE" ]] && ln -sfv "$DOTFILE" ~
done

###########################################
title "Install package managers & packages"
###########################################
if is-macos; then
  title "Installing brew"
  . "$DOTFILES_DIR/install/brew.sh"
  . "$DOTFILES_DIR/install/brew-cask.sh"
fi

# Install work applications, should any exist
if [[ -f "$DOTFILES_DIR/work/install/apps.sh" ]] ; then
  ###########################################
  title "Install work applications"
  ###########################################
  . "$DOTFILES_DIR/work/install/apps.sh"
else
    echo "No work/install/apps.sh exists; not bootstraping work applications!"
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
if [[ -f "$DOTFILES_DIR/work/install/code.sh" ]] ; then
. "$DOTFILES_DIR/work/install/code.sh"
else
    echo "No work/install/code.sh exists; not bootstraping work code!"
fi

##
# If OSX, let's do the dock + settings
##
if is-macos ; then
    sudo . "$DOTFILES_DIR/macos/settings.sh"
    # Run dock.sh last, as the final step kills all items launched from the dock,
    # including the terminal the install.sh script is running from.
    . "$DOTFILES_DIR/macos/dock.sh"
fi
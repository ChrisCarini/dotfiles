#!/usr/bin/env bash

##########################
# Make utilities available
##########################
PATH="$DOTFILES_DIR/bin:$PATH"

# The main method for script finalization
function finalize_script() {
  # If the post-install script flag file exists, remove it
  POST_INSTALL_FLAG_FILE=~/dotfiles/.post-install.sh.flag
  if [ -f "$POST_INSTALL_FLAG_FILE" ]; then
    header "=" "Removing the post-installation flag: $POST_INSTALL_FLAG_FILE"
    rm "$POST_INSTALL_FLAG_FILE"
  fi
}

# Trap the `EXIT` signal and run our cleanup scripts
trap finalize_script EXIT

title "dotfiles Post-Installation Script..."

function open_if_app_exists() {
  if [[ -d "/Applications/$1" ]]; then
    header "-" "Opening $1"
    open "/Applications/$1"
  else
    echo "WARNING: Application $1 does not exist."
  fi
}

##
# If OSX, let's do some stuff...
##
if is-macos; then
  header "=" "Open System Preferences > Touch ID to register fingerprint"
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  #
  #  !!!!! WARNING !!!!!
  #   If you read this and figure out how to click the
  #   magical "Add a fingerprint" button, please let me know!
  #
  # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  osascript <<EOF
tell application "System Preferences"
  activate
  delay 1
  set the current pane to pane id "com.apple.preferences.password"
end tell
EOF

  header "=" "Opening OSX Applications..."

  # Open ShiftIt for the first time - needed to allow system permissions to control machine
  open_if_app_exists "ShiftIt.app"

  # Open Docker for the first time - needed to allow system privileged access
  open_if_app_exists "Docker.app"

  # Install XQuartz; this may require a password prompt, so we delay this until after the user is present.
  header "-" "Installing XQuartz"
  brew cask install xquartz

fi

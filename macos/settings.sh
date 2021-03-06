#!/usr/bin/env bash

# ~/.macos — https://mths.be/macos

##########################
# Make utilities available
##########################
PATH="$DOTFILES_DIR/bin:$PATH"

# ---------------------------------------------------
header "-" "Close any open System Preferences panes." # Prevents them from overriding settings we’re about to change"
# ---------------------------------------------------
osascript -e 'tell application "System Preferences" to quit'

# ========================
header "=" "General UI/UX"
# ========================

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
#sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf ~/Library/Application Support/Dock/desktoppicture.db
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

# --------------------------------------
header "-" "Show the battery percentage"
# --------------------------------------
defaults write com.apple.menuextra.battery ShowPercent YES

# ----------------------------------------------------------
header "-" "Show the Day of Week + Month + Date + 24hr time"
# ----------------------------------------------------------
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  HH:mm:ss"

# -----------------------------------------------------
header "-" "Change the Time Format to use 24-hour time" # (System Preferences > Language & Region > Time Format)
# -----------------------------------------------------
defaults write -g AppleICUForce24HourTime -bool true

# ---------------------------------------------------------------------------------
header "-" "OSX Mojave - Turn off the ScreenShot preview in the lower right corner"
# ---------------------------------------------------------------------------------
defaults write com.apple.screencapture show-thumbnail -bool false

# ======================================================================
header "=" "Trackpad, mouse, keyboard, Bluetooth accessories, and input"
# ======================================================================
# ---------------------------------------------------
header "-" "Disable “natural” (Lion-style) scrolling"
# ---------------------------------------------------
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# -----------------------------------------------------------------
header "-" "Disable press-and-hold for keys in favor of key repeat"
# -----------------------------------------------------------------
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# ------------------------------------------
header "-" "Set a fast keyboard repeat rate"
# ------------------------------------------
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 25

# ----------------------------------------
header "-" "Set language and text formats"
# ----------------------------------------
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en-US"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

# =================
header "=" "Finder"
# =================
# -----------------------------------------------
header "-" "Finder: show hidden files by default"
# -----------------------------------------------
defaults write com.apple.finder AppleShowAllFiles -bool true

# -----------------------------------------------
header "-" "Finder: show all filename extensions"
# -----------------------------------------------
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# ----------------------------------
header "-" "Finder: show status bar"
# ----------------------------------
defaults write com.apple.finder ShowStatusBar -bool true

# --------------------------------
header "-" "Finder: show path bar"
# --------------------------------
defaults write com.apple.finder ShowPathbar -bool true

# ---------------------------------------------------
header "-" "Keep folders on top when sorting by name"
# ---------------------------------------------------
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# -----------------------------------------------
header "-" "Change desktop icon side to be 60x60"
# -----------------------------------------------
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist
killall Finder

# -------------------------------------------------------------------
header "-" "Avoid creating .DS_Store files on network or USB volumes"
# -------------------------------------------------------------------
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# --------------------------------------------------------------------------
header "-" "Automatically open a new Finder window when a volume is mounted"
# --------------------------------------------------------------------------
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# ---------------------------------------------
header "-" "Finder: Show Hard Drive on desktop"
# ---------------------------------------------
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true

# ----------------------------------------------------------
header "-" "Finder: Add desired folders to Finder Favorites"
# ----------------------------------------------------------
if ! [ -x "$(command -v mysides)" ]; then
  echo "'mysides' not installed - executing 'brew cask install mysides' as $(logname) ..."
  # Note: We run this as `su $(logname)` because the settings.sh file is run as sudo (for all the other commands)
  #       and brew will complain and not run if being run with elevated privs.
  su $(logname) -c 'brew cask install mysides'
fi
if [ -x "$(command -v mysides)" ]; then
  echo "'mysides' is installed."

  echo "Removing all existing folders from favorites menu..."
  mysides list | awk -F"->" '{print $1}' | xargs -I {} mysides remove "{}"

  echo "Adding folders to Finder favotires menu..."

  mysides add "Applications" file:///Applications/
  mysides add "Desktop" file:///Users/$USER/Desktop/
  mysides add "Documents" file:///Users/$USER/Documents/
  mysides add "Downloads" file:///Users/$USER/Downloads/
  mysides add "$USER" file:///Users/$USER/
  mysides add "Archive" file:///Users/$USER/Desktop/Archive/
  mysides add "tmp" file:///Users/$USER/tmp/
  mysides add "code" file:///Users/$USER/code
  mysides add "~DELETE THIS STUFF" file:///Users/$USER/Desktop/~DELETE%20THIS%20STUFF/
else
  echo "###################"
  echo "##    WARNING    ##"
  echo "###################"
  echo "##"
  echo "## mysides still is not installed. Nothing added to side bar."
  echo "##"
  echo "##    You can manually install mysides via:"
  echo "##        $ brew cask install mysides"
fi

# ===========================================
header "=" "Dock, Dashboard, and hot corners"
# ===========================================
# ----------------------------------------------------------------------------
header "-" "Enable highlight hover effect for the grid view of a stack (Dock)"
# ----------------------------------------------------------------------------
defaults write com.apple.dock mouse-over-hilite-stack -bool true

# -------------------------------------------------------
header "-" "Set the icon size of Dock items to 36 pixels"
# -------------------------------------------------------
defaults write com.apple.dock tilesize -int 36

# ---------------------------------------------------
header "-" "Enable spring loading for all Dock items"
# ---------------------------------------------------
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# ------------------------------------------------------------------
header "-" "Show indicator lights for open applications in the Dock"
# ------------------------------------------------------------------
defaults write com.apple.dock show-process-indicators -bool true

# ------------------------------------------------------------------------
header "-" "Don’t automatically rearrange Spaces based on most recent use"
# ------------------------------------------------------------------------
defaults write com.apple.dock mru-spaces -bool false

# ==========================
header "=" "Safari & WebKit"
# ==========================
# ------------------------------------------------------
header "-" "Privacy: don’t send search queries to Apple"
# ------------------------------------------------------
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
# -----------------------------------------------------------------------------------
header "-" "Show the full URL in the address bar (note: this still hides the scheme)"
# -----------------------------------------------------------------------------------
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# ------------------------------------------------------------------
header "-" "Enable the Develop menu and the Web Inspector in Safari"
# ------------------------------------------------------------------
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# ---------------------------
header "-" "Disable AutoFill"
# ---------------------------
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# -----------------------------------------
header "-" "Warn about fraudulent websites"
# -----------------------------------------
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# ---------------------------
header "-" "Disable plug-ins"
# ---------------------------
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# -----------------------
header "-" "Disable Java"
# -----------------------
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false

# -------------------------------
header "-" "Block pop-up windows"
# -------------------------------
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# --------------------------------
header "-" "Enable “Do Not Track”"
# --------------------------------
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# ------------------------------------------
header "-" "Update extensions automatically"
# ------------------------------------------
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# =============================
header "=" "Terminal & iTerm 2"
# =============================
# -----------------------------------------
header "-" "Only use UTF-8 in Terminal.app"
# -----------------------------------------
defaults write com.apple.terminal StringEncodings -array 4

# ------------------------------------------------------------
header "-" "Set OSX terminal to automatically close upon exit"
# ------------------------------------------------------------
plutil -replace "Window Settings".Basic.shellExitAction -integer 1 ~/Library/Preferences/com.apple.Terminal.plist

# ===========================
header "=" "Activity Monitor"
# ===========================
# ---------------------------------------------------------------
header "-" "Show the main window when launching Activity Monitor"
# ---------------------------------------------------------------
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# ----------------------------------------------------------------
header "-" "Visualize CPU usage in the Activity Monitor Dock icon"
# ----------------------------------------------------------------
defaults write com.apple.ActivityMonitor IconType -int 5

# -------------------------------------------------
header "-" "Show all processes in Activity Monitor"
# -------------------------------------------------
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# -----------------------------------------------------
header "-" "Sort Activity Monitor results by CPU usage"
# -----------------------------------------------------
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# =====================================
header "=" "TextEdit, and Disk Utility"
# =====================================
# ---------------------------------------------------------
header "-" "Use plain text mode for new TextEdit documents"
# ---------------------------------------------------------
defaults write com.apple.TextEdit RichText -int 0

# ---------------------------------------------------
header "-" "Open and save files as UTF-8 in TextEdit"
# ---------------------------------------------------
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ------------------------------------------------
header "-" "Enable the debug menu in Disk Utility"
# ------------------------------------------------
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# ==================================
header "=" "Misc OSX Customizations"
# ==================================
# --------------------------------------------------------------------------------------------------------
header "-" "Silence the \`zsh\` suggestion in bash on OSX - ref: https://apple.stackexchange.com/a/371998"
# --------------------------------------------------------------------------------------------------------
export BASH_SILENCE_DEPRECATION_WARNING=1

# =====================================
header "=" "Kill affected applications"
# =====================================

# Don't kill the terminal, as that'd kill the script we're running from. ;)
apps=(
  "Activity Monitor"
  "cfprefsd"
  "Finder"
  "Google Chrome Canary"
  "Google Chrome"
  "Safari"
  "SystemUIServer"
)
for app in "${apps[@]}"; do
  killall "${app}" &>/dev/null
done
echo "Done. Note that some of these changes require a logout/restart to take effect."

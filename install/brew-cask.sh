#!/usr/bin/env bash
if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

brew tap homebrew/cask-versions

# Install packages
apps=(
#    atom
#    arduino
#    burp-suite
#    Caffeine
    docker  # This installs the OSX Docker Desktop Application
#    filezilla
    firefox
    flux
    google-chrome
#    google-chrome-canary
    gpg-suite
    intellij-idea
    intellij-idea-ce
    iterm2
#    kitematic
#    mysqlworkbench
    mysides  # Needed to be able to manipulate Finder favorites - See https://github.com/mosen/mysides
    OmniDiskSweeper  # https://www.omnigroup.com/more
    shiftit
    slack
#    spotify
#    sublime-text
    tunnelblick
#    virtualbox
#    visual-studio-code
#    vlc
#    xquartz # For X11 forwarding - NOTE: THIS IS INSTALLED IN post-install.sh BECAUSE IT PROMPTS FOR PASSWORD.
)

for APPLICATION in "${apps[@]}"; do
    # Check if the application is installed with `brew cask`
    brew info --cask $APPLICATION | grep "Not installed" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        # If the application is NOT installed via `brew cask`,
        # check if the application is installed in the system already
        APP_INFO=$(brew info --cask $APPLICATION)
        APP_INFO_RESULT=$?
        stat "/Applications/$(brew info --cask $APPLICATION | grep -A1 Artifacts | tail -n1 | sed 's/\.app.*/.app/')" > /dev/null 2>&1
        if [ $APP_INFO_RESULT -eq 0 && $? -eq 0 ]; then
            echo "$APPLICATION *is* installed, skipping..."
        else
            # Application is not installed, let's install it with `brew cask`
            # Note: The application *may* already be installed still; I'm unsure of a good way to identify this any further
            # Call brew with the envvar to disable auto-update.
            HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $APPLICATION
        fi
    else
        echo "$APPLICATION *is* installed, skipping..."
    fi
done

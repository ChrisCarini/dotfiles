if ! is-macos -o ! is-executable brew; then
  echo "Skipped: Homebrew-Cask"
  return
fi

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

brew tap caskroom/versions

# Install packages
apps=(
    atom
    arduino
    burp-suite
    firefox
    flux
    google-chrome
    google-chrome-canary
    slack
    spotify
    sublime-text
    virtualbox
    visual-studio-code
    vlc
)

for APPLICATION in "${apps[@]}"; do
    # Check if the application is installed with `brew cask`
    brew cask info $APPLICATION | grep "Not installed" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        # If the application is NOT installed via `brew cask`,
        # check if the application is installed in the system already
        stat "/Applications/$(brew cask info $APPLICATION | grep -o ".*.app" | head -n 1)" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo "$APPLICATION *is* installed, skipping..."
        else
            # Application is not installed, let's install it with `brew cask`
            # Note: The application *may* already be installed still; I'm unsure of a good way to identify this any further
            brew cask install $APPLICATION
        fi
    else
        echo "$APPLICATION *is* installed, skipping..."
    fi
done

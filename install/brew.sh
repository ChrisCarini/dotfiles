if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

brew update
brew upgrade

apps=(
  bash-completion
  brew-cask-completion
  coreutils
  git
  git-extras
  imagemagick
  jq
  nano
  python
  ssh-copy-id
  unar
  watch
  wget
)

brew install "${apps[@]}"

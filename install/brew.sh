if ! is-macos -o ! is-executable ruby -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: ruby, curl and/or git)"
  return
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Turn off `brew` analytics
# Docs: https://docs.brew.sh/Analytics.html
brew analytics off

# We need to chown the Cellar directory otherwise brew will complain a lot during the installs below.
sudo chown -R $(whoami) /usr/local/Cellar

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
  libcouchbase
  mosh
  mysql
  nano
  python
  ssh-copy-id
  tree
  unar
  watch
  wget
)

brew install "${apps[@]}"

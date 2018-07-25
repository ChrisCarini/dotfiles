# Chris' dotfiles

These are my dotfiles. Use at your own risk.

These are primarily used on Mac OS systems, but might be able to be used on Linux as well.

## Package overview


## Installation
Below are the 4 simple steps for installation.
### Step 1 - Update Software and Install XCode
On a fresh installation of macOS:
```bash
sudo softwareupdate -i -a
xcode-select --install
```

### Step 2 - Clone the dotfiles
#### Clone with `Git` (_preferred_)
```bash
git clone https://github.com/ChrisCarini/dotfiles.git ~/.dotfiles
```

#### Download with `curl`
```bash
bash -c "`curl -fsSL https://raw.github.com/ChrisCarini/dotfiles/master/remote-install.sh`"
```

#### Download with `wget`
```bash
bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ChrisCarini/dotfiles/master/remote-install.sh`"
```

### Step 3 - Make any needed modifications / additions
#### Is this a work machine?
If so, you can create the below files which will be symlinked instead of the non-work versions:
1. `.gitconfig.work`
1. `.gitignore_global.work`

**Additionally**, the `.bash_profile` is set to source the below files given they exist:
1. `.path.work`
1. `.env.work`
1. `.alias.work`
1. `.functions.work`
1. `.banner.work`  (See [Banners](#banners) section for details)

If this is being used on a work machine, add these files with the respective information if desired.

### Step 4 - Install!
```bash
source ~/.dotfiles/install.sh
```

## Features
### Mac OS Specifics
These dotfiles allow the following Mac OS specific dotfiles to be sourced after all other supported dotfiles:
1. `.path.macos`
1. `.env.macos`
1. `.alias.macos`
1. `.functions.macos`

### Banners
##### How does the banner work?
The banners file(s) need to set the variable `BANNER_OUTPUT`.

Upon sourcing all of the `.banner` files, this variable is printed via:
 ```bash 
printf "$BANNER_OUTPUT"
 ```
##### Banner dotfiles Sourcing Hierarchy
1. `.banner`
1. `.banner_*`
1. `.banner.work`
 
##### Why did I chose to have the banner work this way?
Very simply, because I wanted a different banner for my work environment than my personal. The current implementation allows a  


### The `dotfiles` command
```bash
$ dotfiles help
Usage: dotfiles <command>

Commands:
   clean            Clean up caches (brew)
   dock             Apply macOS Dock settings
   edit             Open dotfiles in IDE (code) and Git GUI (stree)
   help             This help message
   macos            Apply macOS system defaults
   update           Update packages and pkg managers (OS, brew, npm, gem)
```

## Additional resources

* [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Homebrew](https://brew.sh)
* [homebrew-cask](https://caskroom.github.io) / [usage](https://github.com/phinze/homebrew-cask/blob/master/USAGE.md)
* [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)

## Credits

I borrowed (and tweaked) a fair bit from [Lars Kappert's dotfiles](https://github.com/webpro/dotfiles).

Additionally, the [dotfiles community](https://dotfiles.github.io) happens to have a **TON** of great examples of other peoples `dotfiles`.
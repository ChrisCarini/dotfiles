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
git clone git@github.com:ChrisCarini/dotfiles.git ~/dotfiles
```

#### Download with `curl`
```bash
bash -c "`curl -fsSL https://raw.github.com/ChrisCarini/dotfiles/master/remote-install.sh`"
```

#### Download with `wget`
```bash
bash -c "`wget -O - --no-check-certificate https://raw.githubusercontent.com/ChrisCarini/dotfiles/master/remote-install.sh`"
```

### Step 3 - Clone work-specific dotfiles repository
If you **already** have a work-specific repository ready, then you just need to run:
```bash
git clone <URL_TO_WORK_DOTFILES_GIT_REPO> work
```

**Otherwise**, run the below to create the respective work folder and initalize it with `git`.
```bash
mkdir ~/dotfiles/work/
cd ~/dotfiles/work/
git init
source ~/dotfiles/bin/create_work_dotfiles.sh
```

### Step 4 - Install!
```bash
source ~/dotfiles/install.sh
```

## Features
### Mac OS Specifics
These dotfiles allow the following Mac OS specific dotfiles to be sourced after all other supported dotfiles:
1. `.path.macos`
1. `.env.macos`
1. `.alias.macos`
1. `.functions.macos`

### Work Specific dotfiles
This repository allows the creation and use of work-specific dotfiles. Everything is contained under the `$DOTFILES_DIR/work/` directory (which is ignored by this repository). This allows for the two repositories to be maintained individually.

Similar to the structure of this repository, we allow for the following folders:
1. `$DOTFILES_DIR/work/README.md`
1. `$DOTFILES_DIR/work/git`
1. `$DOTFILES_DIR/work/system`

To initalize the dotfiles that can be used in these directories, you can simply run:
```bash
source ~/dotfiles/bin/create_work_dotfiles.sh
```

#### Nuances
The below files will be prefered over the ones contained within this repository.
1. `$DOTFILES_DIR/work/git/.gitconfig`
1. `$DOTFILES_DIR/work/git/.gitignore_global`

### Banners
##### How does the banner work?
The banners file(s) need to set the variable `BANNER_OUTPUT`.

Upon sourcing all of the `.banner` files, this variable is printed via:
 ```bash 
printf "$BANNER_OUTPUT"
 ```
##### Banner dotfiles Sourcing Hierarchy
1. `$DOTFILES_DIR/system/.banner`
1. `$DOTFILES_DIR/system/.banner_*`
1. `$DOTFILES_DIR/work/system/.banner`
1. `$DOTFILES_DIR/work/system/.banner`
 
##### Why did I chose to have the banner work this way?
Very simply, because I wanted a different banner for my work environment than my personal. The current implementation allows this in a fairly trivial manner.


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
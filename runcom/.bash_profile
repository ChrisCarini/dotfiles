# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/dotfiles on all distros)
DOTFILES_DIR="$HOME/dotfiles"

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Read cache
DOTFILES_CACHE="$DOTFILES_DIR/.cache.sh"
[ -f "$DOTFILES_CACHE" ] && . "$DOTFILES_CACHE"

# Finally we can source the dotfiles (order matters!)
for DOTFILE in "$DOTFILES_DIR"/system/.{colors,functions,functions_*,path,env,completion,alias,grep,prompt,custom}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Source the Mac OSX specific dotfiles
if is-macos; then
    for DOTFILE in "$DOTFILES_DIR"/system/.{path,env,alias,functions}.macos; do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
    done
fi

##
# Source the Work specific dotfiles
##
for DOTFILE in "$DOTFILES_DIR"/work/runcom/.bash_profile "$DOTFILES_DIR"/work/system/.{path,env,alias,functions}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

# Export the path
export PATH

# Generate the banner(s), if any
for BANNER_FILE in "$DOTFILES_DIR"/system/.{banner,banner_*}; do
    [ -f "$BANNER_FILE" ] && . "$BANNER_FILE"
done
for BANNER_FILE in "$DOTFILES_DIR"/work/system/.{banner,banner_*}; do
    [ -f "$BANNER_FILE" ] && . "$BANNER_FILE"
done
printf "$BANNER_OUTPUT"

# If the post-install script flag is set, run post-install.sh
POST_INSTALL_FLAG_FILE=~/dotfiles/.post-install.sh.flag
[ -f "$POST_INSTALL_FLAG_FILE" ] && ~/dotfiles/post-install.sh

unset_colors
unset unset_colors

# Clean up
unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Bonus Path Setting... (ugh, volta, why you force-add these...)
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Set GPG_TTY for gpg-agent - https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key#telling-git-about-your-gpg-key
export GPG_TTY=$(tty)

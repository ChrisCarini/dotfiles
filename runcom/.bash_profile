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

# Source the Work specific dotfiles
for DOTFILE in "$DOTFILES_DIR"/work/system/.{path,env,alias,functions}; do
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

unset_colors
unset unset_colors

# Clean up
unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

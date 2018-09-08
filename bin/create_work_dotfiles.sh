#!/usr/bin/env bash
# Resolve DOTFILES_DIR (assuming ~/dotfiles on all distros)
DOTFILES_DIR="$HOME/dotfiles"
BASE_PATH="/work"

if [ ! -f "$DOTFILES_DIR$BASE_PATH/README.md" ]; then
cat << EOF > "$DOTFILES_DIR$BASE_PATH/README.md"
# Chris Carini's work-specific dotfiles
See https://github.com/ChrisCarini/dotfiles for details on this work repository.
EOF
fi

for FILE in "$DOTFILES_DIR$BASE_PATH"/git/.{gitconfig,gitignore_global}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR$BASE_PATH"/system/.{banner,colors,completion,grep,prompt,custom}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR$BASE_PATH"/system/.{path,env,alias,functions}{,.macos}; do
    touch "$FILE"
done

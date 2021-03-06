#!/usr/bin/env bash
# Resolve DOTFILES_DIR (assuming ~/dotfiles on all distros)
DOTFILES_DIR="$HOME/dotfiles"
BASE_PATH=""
for FILE in "$DOTFILES_DIR$BASE_PATH"/git/.{gitconfig,gitignore_global}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR$BASE_PATH"/system/.{banner,colors,completion,grep,prompt,custom}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR$BASE_PATH"/system/.{path,env,alias,functions}{,.macos}; do
    touch "$FILE"
done

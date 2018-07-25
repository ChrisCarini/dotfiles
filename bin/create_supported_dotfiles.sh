#!/usr/bin/env bash
# Resolve DOTFILES_DIR (assuming ~/dotfiles on all distros)
DOTFILES_DIR="$HOME/dotfiles"

for FILE in "$DOTFILES_DIR"/git/.{gitconfig,gitignore_global}{,.work}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR"/system/.{banner,banner.work,colors,completion,grep,prompt,custom}; do
    touch "$FILE"
done

for FILE in "$DOTFILES_DIR"/system/.{path,env,alias,functions}{,.macos,.work}; do
    touch "$FILE"
done

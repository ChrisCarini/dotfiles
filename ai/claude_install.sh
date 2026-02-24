#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"

ln -sfv "$DOTFILES_DIR/ai/claude/CLAUDE.md" ~/.claude
ln -sfv "$DOTFILES_DIR/ai/claude/settings.json" ~/.claude
ln -sfv "$DOTFILES_DIR/ai/claude/statusline.sh" ~/.claude

subdirs=(
  rules
  skills
)
for subdir in "${subdirs[@]}"; do
  # for each directory/file in `$DOTFILES_DIR/ai/claude/${subdir}`, symlink into `~/.claude/${subdir}/
  for file in "$DOTFILES_DIR/ai/claude/${subdir}/"*; do
    ln -sfv "${file}" "${HOME}/.claude/${subdir}"
  done
done
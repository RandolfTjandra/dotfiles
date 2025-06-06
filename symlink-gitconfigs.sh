#!/bin/sh

# Symlink .gitconfig, .gitconfig.dinari, and .gitconfig.personal from this repo to the home directory

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

files=".gitconfig .gitconfig.dinari .gitconfig.personal"

for file in $files; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME_DIR/$file"
    if [ -e "$src" ]; then
        ln -sfn "$src" "$dest"
        echo "Symlinked $src -> $dest"
    else
        echo "Warning: $src does not exist, skipping."
    fi
done

echo "Git config symlinks complete."

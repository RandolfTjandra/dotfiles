# dotfiles

This is my personal dotfiles repository. It manages configuration for my development environment and tools.  
**Note:** A lot of it is a mess right now, so I wouldn't recommend copying any of it directly.  
Feel free to look around if you want though.

---

## Table of Contents

- [Overview](#overview)
- [Setup](#setup)
- [Managed Tools](#managed-tools)
- [Environment Variables](#environment-variables)
- [Extra Tips](#extra-tips)

---

## Overview

This repo contains configuration for:

- Neovim
- Tmux
- Zsh
- Kitty
- Alacritty
- Git
- Karabiner
- Sketchybar
- FZF
- LSD
- Spacebar
- SKHD
- Hammerspoon
- Vim
- Yabai
- and more...

---

## Setup

The setup script creates symlinks from your home/config directories to the files in this repo.

```sh
./setup.sh
```

---

## Managed Tools

This repo manages configuration for (but is not limited to):

- Terminal emulators: Kitty, Alacritty
- Shells: Zsh, Bash
- Editors: Neovim, Vim
- Multiplexer: Tmux
- Window management: Yabai, SKHD, Spacebar, Sketchybar, Hammerspoon, Karabiner
- Utilities: FZF, LSD, Neofetch, Git

---

## Environment Variables

Set the following environment variable in your shell config:

```sh
export DOTS="/Users/randolftjandra/Dev/dotfiles/"
```

---

## Extra Tips

### Tmux setup

```sh
ln -s ~/.config/tmux/.tmux.conf ~/.tmux.conf 
```

### Kitty

List fonts and their family names:

```sh
kitty list-fonts
```

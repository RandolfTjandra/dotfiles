# dotfiles

Personal macOS configuration: Neovim (Lazy), Zsh, Tmux, Kitty, plus window-management tooling (Yabai, SKHD, Sketchybar, Karabiner, etc.). Treat it as a reference rather than a turnkey setup.

---

## What’s included

- **Neovim** – Lua config under `nvim/`, Lazy.nvim plugin specs, dracula/catppuccin themes
- **Shell** – Zsh config, fzf integration, helper scripts under `zsh/`
- **Terminal** – Kitty & Alacritty themes
- **Tmux** – theme, scripts, bindings
- **Window manager** – Yabai, SKHD, Sketchybar widgets
- **Automation** – Hammerspoon, Karabiner, assorted scripts for Kitty, Sketchybar
- **Other** – Git hooks/config, LSD, Neofetch, scripts like `setup.sh` and `symlink-gitconfigs.sh`

Dependencies + fonts live in `requirements.md`.

---

## Getting started (my flow)

```bash
git clone https://github.com/randolftjandra/dotfiles ~/Dev/dotfiles
cd ~/Dev/dotfiles

# Optional: keep DOTFILES handy for scripts
export DOTFILES=$(pwd)

# Symlink configs into $HOME and ~/.config
./setup.sh

# Optional: environment-specific git configs
./symlink-gitconfigs.sh

# First-time Neovim plugin install
nvim +"Lazy sync" +qa

# Optional: check providers / health
nvim -c "checkhealth" -c qa
```

The scripts are idempotent; rerun them after pulling updates. I keep the repo in place and commit changes directly.

---

## Directory map

| Path | Purpose |
| ---- | ------- |
| `nvim/` | Neovim config (Lazy specs, mappings, utilities) |
| `zsh/` | Shell aliases + helper scripts |
| `kitty/`, `alacritty/` | Terminal config & themes |
| `tmux/` | Tmux theme, scripts, bindings |
| `yabai/`, `skhd/` | Window manager & hotkeys |
| `sketchybar/` | Menu bar widgets and scripts |
| `karabiner/` | Keyboard remaps + backups |
| `git/`, `gitconfig/` | Git hooks and environment-specific configs |
| `requirements.md` | External dependencies |

---

## Notes

- `setup.sh` uses `ln -sfn`, so existing files are replaced with symlinks—back up anything custom first.
- Neovim expects `python3`, `node`, `npm`, and `stylua` in `PATH`; install via Homebrew/pyenv/nvm as needed.
- Kitty themes include a bundled Dracula pack (`kitty/themes/kitty-master/`).
- macOS automation tools (Yabai, SKHD, Sketchybar, Karabiner, Hammerspoon) need permissions; follow their docs.
- Git configs support multiple environments (`gitconfig/environments/`).

---

## Caveats

- Opinionated, bleeding-edge—expect breakage between commits.
- No effort to keep compatibility with Linux/WSL.
- Feel free to copy ideas, but adapt to your workflow.

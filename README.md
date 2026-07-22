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
- **Packages** – Homebrew manifest in `Brewfile` for formulae, casks, VS Code extensions, and other bundle-managed tools
- **Other** – Git hooks/config, LSD, Neofetch, home dotfiles under `home/`, local binaries under `bin/`, and scripts like `setup.sh` and `scripts/update-brewfile.sh`

Manual notes live in `docs/requirements.md`.

---

## Getting started (my flow)

```bash
git clone https://github.com/randolftjandra/dotfiles ~/Dev/dotfiles
cd ~/Dev/dotfiles

# Install packages/apps from Homebrew Bundle
brew bundle --file Brewfile

# Optional: keep DOTFILES handy for scripts
export DOTFILES=$(pwd)

# Symlink configs into $HOME and ~/.config
./setup.sh

# First-time Neovim plugin install
nvim +"Lazy sync" +qa

# Optional: check providers / health
nvim -c "checkhealth" -c qa
```

The scripts are idempotent; rerun them after pulling updates. I keep the repo in place and commit changes directly.

When I add or remove Homebrew packages on my main machine, I refresh the tracked manifest with:

```bash
./scripts/update-brewfile.sh
```

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
| `home/` | Dotfiles linked into `$HOME` |
| `bin/` | Local executables linked into `$HOME/.local/bin` |
| `docs/` | Manual setup notes and examples |
| `Brewfile` | Homebrew bundle manifest for packages/apps/extensions |

---

## Notes

- `setup.sh` uses `ln -sfn`, so existing files are replaced with symlinks—back up anything custom first.
- Most CLI tools and desktop apps are captured in `Brewfile`; install them with `brew bundle --file Brewfile`.
- Neovim expects `python3`, `node`, `npm`, and `stylua` in `PATH`; those are included in `Brewfile`, though I still use `pyenv`/`nvm` in shell config too.
- The WaniKani SketchyBar token is loaded at shell startup from `op` when `op` is installed and signed in.
- Kitty themes include a bundled Dracula pack (`kitty/themes/kitty-master/`).
- Terminal/tmux status icons need a Nerd Font. Kitty's `symbol_map` pins them to `FiraCode Nerd Font Mono`, installed via the tracked cask (`brew bundle` covers it, or run `brew install --cask font-fira-code-nerd-font` directly). Only use brew-managed Nerd Font casks—hand-installed font files in `~/Library/Fonts/` drift across Nerd Font versions and render the wrong glyphs.
- macOS automation tools (Yabai, SKHD, Sketchybar, Karabiner, Hammerspoon) need permissions; follow their docs.
- Git configs support multiple environments (`gitconfig/environments/`) and are linked by `setup.sh`.

---

## Caveats

- Opinionated, bleeding-edge—expect breakage between commits.
- No effort to keep compatibility with Linux/WSL.
- Feel free to copy ideas, but adapt to your workflow.

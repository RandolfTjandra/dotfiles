# SketchyBar

This directory is the complete SketchyBar configuration used by these
dotfiles. `sketchybarrc` defines the bar and sources the files under `items/`;
those items invoke the executable scripts under `plugins/`.

The current bar includes spaces and the active window on the left, plus the
calendar, CPU activity, battery, an animated volume slider, WaniKani counts,
and a scrolling Apple Music title on the right. The GitHub and Mail items are
present in the repository but disabled in `sketchybarrc`.

## Installation

SketchyBar requires **Displays have separate Spaces** to be enabled in System
Settings under **Desktop & Dock**. This is the macOS default.

### Install only SketchyBar

`brew bundle --file Brewfile` installs everything in the dotfiles manifest. If
this repository is already cloned and only SketchyBar is missing, run these
commands from the repository root instead:

```sh
# Installs SketchyBar and the dependency used by this configuration's plugins.
brew install felixkratz/formulae/sketchybar jq

# Installs the font used for the Nerd Font separator glyph.
brew install --cask font-hack-nerd-font

# Makes this repository's config the one SketchyBar reads.
mkdir -p "$HOME/.config"
ln -s "$PWD/sketchybar" "$HOME/.config/sketchybar"

# Starts SketchyBar now and automatically at login.
brew services start sketchybar
```

If `~/.config/sketchybar` already exists, follow the existing-configuration
step below before creating the symlink.

Yabai is optional for the bar itself, but its space-click actions and window
mode indicator require it. Install it separately with
`brew install koekeishiya/formulae/yabai` if it is not already present.

### Install all dotfiles

For a new Mac that should receive the complete package manifest and all tracked
dotfile links, use the repository-wide setup:

```sh
brew bundle --file Brewfile
./setup.sh
brew services start sketchybar
```

Do not copy Homebrew's example `sketchybarrc` in either flow. The symlink makes
SketchyBar read this repository's configuration and plugins directly.

In detail:

- `Brewfile` installs `felixkratz/formulae/sketchybar`. It also includes `jq`,
  the fonts used by the bar, Yabai, and the optional 1Password CLI integration.
- `setup.sh` links the repository's `sketchybar/` directory to
  `~/.config/sketchybar` as part of linking all tracked dotfiles. It does not
  install or start SketchyBar.
- The Homebrew service launches SketchyBar at login. SketchyBar executes
  `~/.config/sketchybar/sketchybarrc`, which loads the tracked item and plugin
  scripts through that same symlink.

If SketchyBar is already running, use `brew services restart sketchybar`
instead of `start`.

### Existing local configuration

On a machine where `~/.config/sketchybar` is already a real directory rather
than a symlink, move it aside before creating the repository symlink:

```sh
mv ~/.config/sketchybar ~/.config/sketchybar.backup
ln -s "$PWD/sketchybar" "$HOME/.config/sketchybar"
```

This avoids nesting the repository symlink inside the existing directory and
keeps the previous configuration recoverable. For the complete dotfiles flow,
run `./setup.sh` after the `mv` instead of the `ln` command.

## WaniKani credentials

The `wk` item first looks for `WK_API_KEY` (or the older `WK_KEY`) in the
untracked file `~/.config/sketchybar/.env`:

```sh
WK_API_KEY=your_token_here
```

Because `~/.config/sketchybar` points into this repository, that file appears
as `sketchybar/.env`; it is ignored by Git and must never be committed.

If no environment file is present and the 1Password CLI is installed and
signed in, the plugin instead reads `op://Personal/Wanikani API key/password`.
Without either credential source, the bar still runs and the item displays
`no api key`.

## Applying changes

After pulling or editing this configuration, reload the running bar:

```sh
sketchybar --reload
```

The configuration is symlinked, not copied, so there is no separate sync or
plugin installation step.

Useful service commands:

```sh
brew services list | grep sketchybar
brew services restart sketchybar
brew services stop sketchybar
```

## Troubleshooting

If the service starts but the bar or a widget is not working, stop the service
and run SketchyBar in the foreground to see configuration and plugin errors:

```sh
brew services stop sketchybar
sketchybar
```

Also check:

- `readlink ~/.config/sketchybar` should point to this repository's
  `sketchybar` directory.
- `jq` must be available for the volume, music, Yabai, and WaniKani plugins.
- Yabai-dependent space/window actions require Yabai to be installed, running,
  and granted its normal macOS permissions.
- macOS may ask for Automation permission when the volume or Music controls
  first use AppleScript.
- The Music item is hidden unless Apple Music is currently playing.

When finished debugging in the foreground, press `Ctrl-C` and restore the
login service with `brew services start sketchybar`.

See the upstream [SketchyBar setup guide](https://felixkratz.github.io/SketchyBar/setup)
and [configuration documentation](https://felixkratz.github.io/SketchyBar/config/bar)
for details about SketchyBar itself.

# cursor-fx under herdr

Local fixes that make [ghostty-cursor-fx](https://github.com/Avarce/ghostty-cursor-fx)
(animated cursor shaders for Ghostty) work when Claude Code or zsh runs inside
**herdr**, the terminal multiplexer. Without them the always-on cursor look works,
but the Enter/done effects, the input-box line tint and the ❯ prompt glow never
fire inside a herdr pane.

## Installing on a new machine

`cursor-fx` itself is not in this repo. It comes from upstream,
<https://github.com/Avarce/ghostty-cursor-fx>, and is installed with its
`install.sh`. This repo holds the patched shaders, the presets, the hooks and the
herdr helper. Order matters: upstream's installer copies its unpatched shaders
into `~/.config/ghostty`, which links to this repo, so the patch runs last.

```sh
cd ~/Dev/dotfiles && ./setup.sh                    # links ghostty/, hooks, cursor-fx-signal
git clone https://github.com/Avarce/ghostty-cursor-fx ~/Dev/ai/ghostty-cursor-fx
~/Dev/ai/ghostty-cursor-fx/install.sh              # installs ~/.local/bin/cursor-fx (and overwrites the shaders)
~/Dev/dotfiles/ghostty/cursor-fx/patch-herdr.py    # re-applies the herdr patch
```

Afterwards `git status` in this repo should be clean. If `ghostty/shaders/` shows
changes, the patch no longer matches upstream's code. See "For agents" below.
Without `cursor-fx` on `PATH`, the hooks fail silently and the zsh hook doesn't
load, so only the always-on cursor look works.

## What's here

| File | What it does |
|---|---|
| `patch-herdr.py` | Patches the shaders in `../shaders/*-cursor.glsl` in place. Idempotent: prints `already patched` for files it has done. |
| `cursor-fx-signal` | Wrapper around `cursor-fx signal [done]` that, inside herdr, sends the signal to the Ghostty terminal herdr is drawn in. `setup.sh` links it to `~/.local/bin/cursor-fx-signal`. |

## The two problems it fixes

1. **The signal never reached Ghostty.** `cursor-fx signal` works by nudging the
   cursor color (OSC 12) on the caller's tty. Inside herdr that tty is herdr's
   inner pane, and herdr does not forward the color change to the outer terminal.
   `cursor-fx-signal` checks `$HERDR_ENV`, finds each `herdr` client process whose
   parents include `Ghostty.app`, and signals that client's tty instead. Outside
   herdr it just runs `cursor-fx signal "$@"`.
2. **The shaders never found Claude Code's input box.** Upstream checks for a box
   line by sampling fixed fractions of the *window* width (5%, 45%, 66%, 88%, 95%),
   so a line only counts if it spans the whole window. In herdr the box spans one
   pane, and the sidebar sits under the 5% sample. The patch replaces those checks
   with `acrossPane()`, which counts a line when its ink runs unbroken through the
   cursor's column for at least `BOX_MIN_CELLS` (24) cells. It still works in a
   plain Ghostty tab.

The patch also keeps effects inside Claude Code's pane. Upstream draws them across
the whole window. The original `mainImage` becomes `fxImage`, and a new `mainImage`
wraps it. For any pixel an effect changed, the wrapper finds the pane's edges with
`paneSpan()`, following the box line left and right from the cursor until its color
changes. Pixels outside those edges get the terminal's original pixel back. With
no box nearby (a shell pane) nothing is clipped, so a shell's Enter effect still
spans the window.

## How it's wired

- `../../claude/settings.json`: `UserPromptSubmit` runs `cursor-fx-signal`, `Stop` runs
  `cursor-fx-signal done` (both `async`).
- `../../home/.zshrc`: the upstream zsh hook block, changed to also activate when
  `$HERDR_ENV` is set (herdr panes don't inherit `$GHOSTTY_RESOURCES_DIR`), and to
  call `cursor-fx-signal` inside herdr.
- `../config`: `config-file = cursor-effects/<name>.conf` picks the active effect.

## For agents: when to act

- **After upstream's `install.sh` runs, or after updating the shaders from upstream:**
  `install.sh` overwrites `ghostty/shaders/` with unpatched copies. Rerun
  `ghostty/cursor-fx/patch-herdr.py` (no arguments needed), then reload Ghostty
  (`pkill -USR2 -f /Applications/Ghostty.app/Contents/MacOS/ghostty`, or Cmd+Shift+,).
- **New machine, or `cursor-fx` missing from `~/.local/bin`:** follow "Installing on
  a new machine" above. Don't copy `cursor-fx` into this repo: upstream is the
  source for it.
- **The patch exits with `<step>: expected N, got M`:** upstream changed the code
  it matches. The failing file is left untouched (the script quits before writing).
  Read that shader's box-line functions (`boxLineY`, `clLineNear`, `linesLook`,
  `clMarkAbove`, `clLineBetween`, the `far` branch of `linesLook`, plus cyber's
  `fullLine`/`lineIn`), and extend the matching step in
  `patch-herdr.py` rather than hand-editing the shader, so it stays repeatable.
  The run should end with `leftover-window-checks=0` for every file.
- **Don't run upstream's `sync-from-ghostty.sh`** unless you mean to send these
  patched shaders upstream: it copies the live (patched) files back into the clone.

## Checking it works

- `tail ~/.cache/cursor-fx/signal.log` shows each signal and the tty it went to.
  Inside herdr that tty should belong to a herdr client in Ghostty, not the pane's
  own tty. Compare against `ps -o pid,tty,command -p $(pgrep -x herdr)`.
- Ghostty doesn't write shader compile errors anywhere readable, and there's no
  GLSL compiler here. A broken shader shows as a **plain block cursor** (no effect),
  so ask the user to look after a reload.
- A quick test that color changes reach Ghostty: write `\033]12;#00a0ff\007` to the
  herdr client's tty (the cursor turns blue), then `\033]112\007` to reset. Run
  `cursor-fx enter off` first, or the next hook resets the color, and
  `cursor-fx enter on` after.

## Related Ghostty settings in `../config`

`macos-option-as-alt = true` and `keybind = alt+arrow_left/right=unbind` are there
so herdr's Alt bindings work. Ghostty binds Alt+←/→ to word jumps by default. They
don't depend on cursor-fx.

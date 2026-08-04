#!/usr/bin/env bash
# Piecemeal installer for parts of this dotfiles repo. Unlike setup.sh (which
# links everything), this installs one component at a time, selected below.
set -euo pipefail

if [ -z "${DOTFILES:-}" ]; then
  DOTFILES="$(cd "$(dirname "$0")" && pwd)"
  export DOTFILES
fi

install_claude_statusline() {
  local claude_dir="$HOME/.claude"
  local settings="${claude_dir}/settings.json"
  local statusline_src="${DOTFILES}/claude/statusline.sh"
  local statusline_dest="${claude_dir}/statusline.sh"

  if [ ! -e "$statusline_src" ]; then
    echo "Error: $statusline_src does not exist." >&2
    return 1
  fi

  mkdir -p "$claude_dir"
  ln -sfn "$statusline_src" "$statusline_dest"
  echo "Linked $statusline_src -> $statusline_dest"

  if [ ! -e "$settings" ]; then
    echo '{}' >"$settings"
  fi

  # settings.json is normally a symlink into this repo (see setup.sh). Edit
  # through it via the resolved target so it stays a symlink instead of
  # getting replaced by a plain file that's detached from the repo.
  local settings_target="$settings"
  if [ -L "$settings" ]; then
    settings_target="$(readlink "$settings")"
  fi

  if command -v jq >/dev/null 2>&1 && jq -e '.statusLine' "$settings_target" >/dev/null 2>&1; then
    local current
    current="$(jq -c '.statusLine' "$settings_target")"
    echo "settings.json already has a statusLine set: $current"
    read -r -p "Overwrite it with the dotfiles statusline? [y/N] " reply
    case "$reply" in
      [yY]|[yY][eE][sS]) ;;
      *)
        echo "Skipped updating statusLine in $settings_target."
        return 0
        ;;
    esac
  fi

  local tmp
  tmp="$(mktemp)"
  jq --arg cmd "\$HOME/.claude/statusline.sh" \
    '.statusLine = {"type": "command", "command": $cmd}' \
    "$settings_target" >"$tmp"
  mv "$tmp" "$settings_target"
  echo "Set statusLine in $settings_target."
}

install_claude_statusline

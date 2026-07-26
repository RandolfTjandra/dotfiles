#!/usr/bin/env bash
# Claude Code Stop/Notification hook → terminal-notifier, terminal sessions only.
set -euo pipefail

input=$(cat)
field() { printf '%s' "$input" | python3 -c "import sys,json;print(json.load(sys.stdin).get('$1',''))" 2>/dev/null; }

transcript_path=$(field transcript_path)
cwd=$(field cwd)
event=$(field hook_event_name)

# Only notify for terminal (cli) sessions; stay silent for desktop-spawned ones.
ep=$(grep -m1 -o '"entrypoint":"[^"]*"' "$transcript_path" 2>/dev/null || true)
case "$ep" in
  *cli*) ;;        # terminal → continue
  *) exit 0 ;;     # claude-desktop / unknown → silent
esac

proj=$(basename "${cwd:-$PWD}")
tn=$(command -v terminal-notifier || echo /opt/homebrew/bin/terminal-notifier)

# Find the .app that owns this session's terminal, so clicking the notification
# comes back here. Nothing about any specific terminal is hardcoded: we walk up
# the process tree until we hit an executable living inside a bundle, then ask
# the bundle for its own identifier.
bundle_of_pid() {
  local p="${1:-}" cmd app
  for _ in 1 2 3 4 5 6 7 8; do
    case "$p" in ''|0|1) return 1 ;; esac
    cmd=$(ps -o comm= -p "$p" 2>/dev/null || true)
    case "$cmd" in
      */*.app/Contents/MacOS/*)
        app="${cmd%%.app/Contents/MacOS/*}.app"
        defaults read "$app/Contents/Info" CFBundleIdentifier 2>/dev/null || return 1
        return 0 ;;
    esac
    p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ' || true)
  done
  return 1
}

# Under tmux the server is reparented to launchd, so the terminal is nowhere in
# our ancestry. Go via the attached client's tty instead. Prefer the client
# showing our own pane; fall back to the sole client when $TMUX is not exported.
tmux_client_tty() {
  local t=""
  if [ -n "${TMUX_PANE:-}" ]; then
    t=$(tmux display-message -p -t "$TMUX_PANE" '#{client_tty}' 2>/dev/null || true)
  fi
  if [ -z "$t" ]; then
    t=$(tmux list-clients -F '#{client_tty}' 2>/dev/null | head -1 || true)
  fi
  printf '%s' "$t"
}

in_tmux=""
[ -n "${TMUX:-}" ] && in_tmux=1
bundle=$(bundle_of_pid "$PPID" || true)
if [ -z "$bundle" ] && command -v tmux >/dev/null 2>&1; then
  ctty=$(tmux_client_tty)
  if [ -n "$ctty" ]; then
    in_tmux=1
    owner=$(ps -t "${ctty#/dev/}" -o pid= 2>/dev/null | head -1 | tr -d ' ' || true)
    bundle=$(bundle_of_pid "$owner" || true)
  fi
fi

case "$event" in
  Notification) title="🔔 Claude Code"; message="$proj needs your input" ;;
  *)            title="✅ Claude Code"; message="$proj — task complete" ;;
esac

args=(-title "$title" -message "$message" -group "claude-code-$proj")
if [ -n "$bundle" ] && [ -n "$in_tmux" ] && [ -n "${TMUX_PANE:-}" ]; then
  # Raising the terminal is not enough inside tmux -- the click also has to
  # select the window and pane the notification came from. tmux needs no
  # special permission for this, unlike a terminal's own remote-control API.
  tmuxbin=$(command -v tmux)
  args+=(-execute "open -b '$bundle'; '$tmuxbin' select-window -t '$TMUX_PANE'; '$tmuxbin' select-pane -t '$TMUX_PANE'")
elif [ -n "$bundle" ]; then
  args+=(-activate "$bundle")
fi

"$tn" "${args[@]}" >/dev/null 2>&1 || true
exit 0

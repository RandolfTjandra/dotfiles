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

case "$event" in
  Notification) title="🔔 Claude Code"; message="$proj needs your input" ;;
  *)            title="✅ Claude Code"; message="$proj — task complete" ;;
esac

"$tn" -title "$title" -message "$message" -group "claude-code-$proj" >/dev/null 2>&1 || true
exit 0

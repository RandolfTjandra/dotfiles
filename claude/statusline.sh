#!/usr/bin/env bash
# Claude Code status line.
# Reads the status JSON on stdin and prints a single-line status.
# Segments: <model> <effort> │ <user> in <dir> │ <branch> +added -removed · ctx NN%

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty')

short=$(printf '%s' "$cwd" | sed "s|^$HOME|~|")
user=$(whoami)
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

if [ -n "$effort" ]; then
  prefix="$model $effort"
else
  prefix="$model"
fi

# Context usage: last main-chain assistant message's prompt size / 200k window.
ctx=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  ctx=$(python3 - "$transcript" <<'PY' 2>/dev/null
import sys, json
last = None
try:
    with open(sys.argv[1]) as fh:
        for line in fh:
            try:
                o = json.loads(line)
            except Exception:
                continue
            if o.get("isSidechain"):
                continue
            msg = o.get("message") or {}
            if msg.get("role") != "assistant":
                continue
            u = msg.get("usage")
            if u:
                last = u
except Exception:
    pass
if last:
    used = (last.get("input_tokens", 0)
            + last.get("cache_creation_input_tokens", 0)
            + last.get("cache_read_input_tokens", 0))
    print(round(used * 100 / 200000))
PY
)
fi

# Color the context segment by how full it is.
ctx_seg=""
if [ -n "$ctx" ]; then
  if [ "$ctx" -ge 80 ]; then
    color=31   # red
  elif [ "$ctx" -ge 50 ]; then
    color=33   # yellow
  else
    color=32   # green
  fi
  ctx_seg=$(printf ' \033[90m\xc2\xb7 ctx\033[0m \033[%sm%s%%\033[0m' "$color" "$ctx")
fi

if [ -n "$branch" ]; then
  stat=$(git -C "$cwd" diff HEAD --numstat 2>/dev/null | awk '{a+=$1; d+=$2} END {printf "%d %d", a, d}')
  added=${stat% *}
  removed=${stat#* }
  printf '\033[35m%s\033[0m \xe2\x94\x82 \033[36m%s\033[0m in \033[33m%s\033[0m \xe2\x94\x82 %s \033[32m+%s\033[0m \033[31m-%s\033[0m%s\n' \
    "$prefix" "$user" "$short" "$branch" "$added" "$removed" "$ctx_seg"
else
  printf '\033[35m%s\033[0m \xe2\x94\x82 \033[36m%s\033[0m in \033[33m%s\033[0m%s\n' \
    "$prefix" "$user" "$short" "$ctx_seg"
fi

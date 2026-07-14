#!/usr/bin/env bash
# Claude Code status line.
# Reads the status JSON on stdin and prints a single-line status.
# Segments: <model> <effort> │ <user> in <dir> │ <branch> +added -removed · ctx NN%
#
# Available input fields (Claude Code v2.1.x), for adding more segments later.
# All are already on stdin every render -- just pull with jq, no extra data source:
#   .cwd                                   working directory
#   .model.id / .model.display_name        e.g. "claude-opus-4-8" / "Opus 4.8"
#   .effort.level                          reasoning effort, e.g. "high"
#   .fast_mode                             bool -- fast mode on
#   .thinking.enabled                      bool -- extended thinking on
#   .context_window.used_percentage        context used %, scaled to real window
#   .context_window.remaining_percentage   context left %
#   .context_window.context_window_size    200000 or 1000000
#   .rate_limits.five_hour.used_percentage rolling 5h quota used %
#   .rate_limits.seven_day.used_percentage rolling 7d quota used %
#   .cost.total_cost_usd                   session spend, USD
#   .cost.total_duration_ms                session wall-clock time, ms
#   .cost.total_lines_added / _removed     lines changed this session
#   .pr.number / .pr.url                   PR for the current branch, if any
#   .session_id / .session_name            session identifiers
#   .transcript_path                       path to this session's JSONL transcript
#   .workspace.project_dir                 repo root; .workspace.repo.{host,owner,name}
#   .version                               Claude Code version
# Capture a live sample to inspect: point the statusLine command at a wrapper
# that tees stdin to a file, then read it.

input=$(cat)

cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
model=$(printf '%s' "$input" | jq -r '.model.display_name // empty')
effort=$(printf '%s' "$input" | jq -r '.effort.level // empty')
# Context usage: Claude Code reports it directly, already scaled to the real
# window (200k or 1m), so it matches /context. Round to an integer.
ctx=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty | if . == "" then "" else (.|round) end')

short=$(printf '%s' "$cwd" | sed "s|^$HOME|~|")
user=$(whoami)
branch=$(git -C "$cwd" branch --show-current 2>/dev/null)

if [ -n "$effort" ]; then
  prefix="$model $effort"
else
  prefix="$model"
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

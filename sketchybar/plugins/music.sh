#!/usr/bin/env bash

# Renders the currently playing Apple Music track.
#
# Two update paths:
#   - music_change : Music.app broadcasts com.apple.iTunes.playerInfo on every
#                    track/state change. sketchybar hands us its payload in
#                    $INFO, so the common case costs no AppleScript at all.
#   - forced/wake  : fall back to asking Music.app directly once at startup or
#                    after the system wakes. There is deliberately no polling.

source "$HOME/.config/sketchybar/icons.sh"

hide() {
  sketchybar --set "$NAME" drawing=off label="" 2>/dev/null
  exit 0
}

# Never let `tell application "Music"` be the thing that launches Music.
pgrep -xq "Music" || hide

# Both sources are normalised to three lines: state, track, artist. Fields are
# read one line at a time so that titles containing spaces survive intact.
if [ "$SENDER" = "music_change" ] && [ -n "$INFO" ]; then
  fields=$(echo "$INFO" |
    jq -r '[."Player State" // "", .Name // "", .Artist // ""] | .[]' 2>/dev/null)
else
  fields=$(osascript <<'APPLESCRIPT' 2>/dev/null
tell application "Music"
  if it is not running then return ""
  set s to player state as text
  if s is not "playing" then return s
  try
    return s & linefeed & (name of current track) & linefeed & (artist of current track)
  on error
    return s
  end try
end tell
APPLESCRIPT
  )
fi

{
  IFS= read -r state
  IFS= read -r track
  IFS= read -r artist
} <<EOF
$fields
EOF

# Player state casing differs between the two sources; normalise it.
state=$(echo "$state" | tr '[:upper:]' '[:lower:]')

[ "$state" = "playing" ] || hide
[ -n "$track" ] || hide

if [ -n "$artist" ]; then
  label="$track — $artist"
else
  label="$track"
fi

sketchybar --set "$NAME" drawing=on icon="$MUSIC" label="$label"

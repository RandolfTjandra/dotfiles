#!/usr/bin/env bash

#  *  Denotes the current window.
#  -  Marks the last window (previously selected).
#  #  Window activity is monitored and activity has been detected.
#  !  Window bells are monitored and a bell has occurred in the window.
#  ~  The window has been silent for the monitor-silence interval.
#  M  The window contains the marked pane.
#  Z  The window's active pane is zoomed.

# Exit after any failed command
set -e

option="\#{window_flags}"

# Glyphs used by the substitutions below; codepoints and names were
# verified against FiraCodeNerdFont-Regular.ttf. All sit in the Font Awesome
# range (U+F0xx) except Z, which uses a Material Design glyph (U+F004C).
# Reference (glyph / name / codepoint):
#   *  ->     fa-map_marker        U+F041
#   -  ->     fa-undo              U+F0E2
#   #  ->     fa-flash             U+F0E7
#   !  ->     fa-bell              U+F0F3
#   ~  ->     fa-bell_slash        U+F1F6
#   M  ->     fa-bookmark          U+F02E
#   Z  ->  󰁌   md-arrow_expand_all  U+F004C

while IFS=\n read value; do
    mappings+=($value)
done <<-EOM
s/*//
s/-//
s/#//
s/!//
s/~//
s/M//
s/Z/󰁌/
EOM
# cool zoom alternative:   fa-expand  U+F065

sed_script="$(
    IFS=';'
    echo "${mappings[*]}"
)"

# The extra replacment adds spaces between each character
formatting_script="sed -e '${sed_script}g'"
flags_value=" #(printf '%%s\n' '#F' | ${formatting_script})"

for setting in window-status-format window-status-current-format; do
    status_value="$(tmux show-option -gqv ${setting})"
    tmux set-option -gq $setting "${status_value/$option/$flags_value}"
done

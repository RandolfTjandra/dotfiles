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

# Glyphs use the Font Awesome range (U+F0xx), which is stable across
# Nerd Font versions. Reference (name / codepoint):
#   *  ->    circle        U+F111
#   -  ->    undo/back     U+F0E2
#   #  ->    bolt          U+F0E7
#   !  ->    bell          U+F0F3
#   ~  ->    bell-slash    U+F1F6
#   M  ->    bookmark      U+F02E
#   Z  ->    expand        U+F065

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
# cool zoom alternative: 

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

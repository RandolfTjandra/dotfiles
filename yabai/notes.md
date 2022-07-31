# stack target_window_sel onto source_window_sel
yabai -m window [<source_window_sel>] --stack <target_window_sel>

# next window is inserted onto source_window_sel
yabai -m window [<source_window_sel>] --insert stack

# focus the prev window in a stack
yabai -m window --focus stack.prev

# focus the next window in a stack
yabai -m window --focus stack.next

# focus the first window in a stack
yabai -m window --focus stack.first

# focus the last window in a stack
yabai -m window --focus stack.last

# focus the most recently focused window in a stack
yabai -m window --focus stack.recent

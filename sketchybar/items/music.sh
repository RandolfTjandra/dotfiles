#!/usr/bin/env sh

# Music.app posts this distributed notification on every track / state change,
# still under the legacy iTunes name.
sketchybar --add event music_change com.apple.iTunes.playerInfo

sketchybar --add       item        music right                     \
           --set       music       drawing=off                     \
                                   updates=on                      \
                                   scroll_texts=on                 \
                                   icon=$MUSIC                     \
                                   icon.color=$RED                 \
                                   label.color=$LABEL_COLOR        \
                                   label.max_chars=30              \
                                   label.scroll_duration=225       \
                                   background.padding_right=10     \
                                   script="$PLUGIN_DIR/music.sh"   \
                                   click_script="osascript -e 'tell application \"Music\" to playpause'" \
           --subscribe music       music_change                    \
                                   system_woke

#!/usr/bin/env sh

# Keep the slider collapsed until macOS reports a volume change. The plugin
# animates it open and closed and handles clicks/drags while it is visible.
sketchybar --add slider volume right 80 \
	--set volume script="$PLUGIN_DIR/volume.sh" \
	updates=on \
	icon.drawing=off \
	label=off \
	label.drawing=off \
	padding_left=1 \
	padding_right=1 \
	slider.width=0 \
	slider.highlight_color=$BLUE \
	slider.background.height=5 \
	slider.background.corner_radius=3 \
	slider.background.color=$GREY \
	slider.knob=􀀁 \
	slider.knob.font="$FONT:Regular:11.0" \
	slider.knob.color=$WHITE \
	--subscribe volume volume_change mouse.clicked mouse.entered mouse.exited \
	--add item volume.icon right \
	--set volume.icon script="$PLUGIN_DIR/volume.sh" \
	updates=on \
	icon=$VOLUME_0 \
	icon.font="$FONT:Regular:12.0" \
	icon.highlight_color=$BLUE \
	icon.padding_left=2 \
	icon.padding_right=2 \
	label=off \
	label.drawing=off \
	padding_left=1 \
	padding_right=1 \
	--subscribe volume.icon mouse.entered mouse.exited

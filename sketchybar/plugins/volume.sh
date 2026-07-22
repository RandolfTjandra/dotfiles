#!/usr/bin/env sh

. "$HOME/.config/sketchybar/icons.sh"

SLIDER_WIDTH=80
SLIDER_NAME=volume
ICON_NAME=volume.icon

set_volume_icon() {
	volume=$1

	case "$volume" in
	[6-9][0-9] | 100) icon=$VOLUME_100 ;;
	3[0-9] | 4[0-9] | 5[0-9]) icon=$VOLUME_66 ;;
	1[1-9] | 2[0-9]) icon=$VOLUME_33 ;;
	[1-9] | 10) icon=$VOLUME_10 ;;
	*) icon=$VOLUME_0 ;;
	esac

	sketchybar --set "$ICON_NAME" icon="$icon"
}

volume_is_hovered() {
	slider_hovered=$(sketchybar --query "$SLIDER_NAME" | jq -r '.label.value')
	icon_hovered=$(sketchybar --query "$ICON_NAME" | jq -r '.label.value')
	[ "$slider_hovered" = "on" ] || [ "$icon_hovered" = "on" ]
}

initialize_volume() {
	volume=$(osascript -e 'output volume of (get volume settings)')
	set_volume_icon "$volume"
	sketchybar --set "$SLIDER_NAME" slider.percentage="$volume" slider.width=0
}

show_volume() {
	set_volume_icon "$INFO"
	sketchybar --set "$SLIDER_NAME" slider.percentage="$INFO" \
		--animate tanh 30 --set "$SLIDER_NAME" slider.width="$SLIDER_WIDTH"

	sleep 2

	# A newer volume event owns the slider if its percentage has changed, so
	# only the latest event is allowed to collapse it. Keep it open while the
	# persistent icon is hovered so the pointer can move onto the slider.
	final_percentage=$(sketchybar --query "$SLIDER_NAME" | jq -r '.slider.percentage')
	if [ "$final_percentage" = "$INFO" ] && ! volume_is_hovered; then
		sketchybar --animate tanh 30 --set "$SLIDER_NAME" slider.width=0
	fi
}

show_hovered_volume() {
	sketchybar --set "$NAME" label=on \
		--set "$ICON_NAME" icon.highlight=on \
		--animate tanh 30 --set "$SLIDER_NAME" slider.width="$SLIDER_WIDTH"
}

hide_hovered_volume() {
	sketchybar --set "$NAME" label=off
	sleep 2

	if ! volume_is_hovered; then
		sketchybar --set "$ICON_NAME" icon.highlight=off \
			--animate tanh 30 --set "$SLIDER_NAME" slider.width=0
	fi
}

set_volume() {
	osascript -e "set volume output volume $PERCENTAGE"
}

case "$SENDER" in
volume_change)
	show_volume
	;;
mouse.clicked)
	set_volume
	;;
mouse.entered)
	show_hovered_volume
	;;
mouse.exited)
	hide_hovered_volume
	;;
forced)
	initialize_volume
	;;
esac

#!/usr/bin/env sh

# Icons are SF Symbols, matching the rest of the config. These only render in
# "SF Pro" -- the Nerd Font glyphs this script used to carry are absent from it,
# which is why the battery icon rendered as an empty box.
. "$HOME/.config/sketchybar/icons.sh"

BATT=$(pmset -g batt)
PERCENTAGE=$(echo "$BATT" | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(echo "$BATT" | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
	exit 0
fi

case ${PERCENTAGE} in
9[0-9] | 100)
	ICON=$BATTERY_100
	;;
[6-8][0-9])
	ICON=$BATTERY_75
	;;
[3-5][0-9])
	ICON=$BATTERY_50
	;;
[1-2][0-9])
	ICON=$BATTERY_25
	;;
*) ICON=$BATTERY_0 ;;
esac

if [ -n "$CHARGING" ]; then
	ICON=$BATTERY_CHARGING
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"

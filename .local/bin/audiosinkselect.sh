#!/bin/bash
# Change audio sink with rofi
# Reference:
#   1. https://www.reddit.com/r/archlinux/comments/14idhhk/bash_script_to_change_default_audio_sink_using/
#   2. https://github.com/zbaylin/rofi-wifi-menu/blob/master/rofi-wifi-menu.sh
# -------------------------
# Create an associative array
declare -A sinks

# Get the list of sinks and their descriptions
sink_info=$(pactl list sinks)

# Retrieve the names and descriptions using sed
names=$(echo "$sink_info" | sed -n 's/.*Name: \(.*\)/\1/p')
descriptions=$(echo "$sink_info" | sed -n 's/.*Description: \(.*\)/\1/p')

# Populate the associative array
IFS=$'\n' read -r -d '' -a names_arr <<<"$names"
IFS=$'\n' read -r -d '' -a descriptions_arr <<<"$descriptions"

for ((i = 0; i < ${#descriptions_arr[@]}; i++)); do
    sinks["${descriptions_arr[$i]}"]="${names_arr[$i]}"
done

# -----------------------
# Populate the rofi menu
# -----------------------
## Obtain the style settings
ConfDir="${XDG_CONFIG_HOME:-$HOME/.config}"
roDir="$ConfDir/rofi"
roconf="$roDir/audiolist.rasi"

desc_width=1
for desc in "${descriptions_arr[@]}"; do
    len=${#desc}
    ((len > desc_width)) && desc_width=$len
done
# ------------------------------------------
# set position
# ------------------------------------------
x_offset=150   #* Cursor spawn position
y_offset=50   #* To point the Cursor to the 1st and 2nd latest item
#? Monitor resolution , scale and rotation
x_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
y_mon=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .height')
#? Rotated monitor?
monitor_rot=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .transform')
if [ "$monitor_rot" == "1" ] || [ "$monitor_rot" == "3" ]; then  # if rotated 270 deg
 tempmon=$x_mon
    x_mon=$y_mon
    y_mon=$tempmon
#! For rotated monitors
fi
#? Scaled monitor Size
monitor_scale=$(hyprctl -j monitors | jq '.[] | select (.focused == true) | .scale' | sed 's/\.//')
x_mon=$((x_mon * 100 / monitor_scale ))
y_mon=$((y_mon * 100 / monitor_scale))
#? monitor position
x_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .x')
y_pos=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .y')
#? cursor position
x_cur=$(hyprctl -j cursorpos | jq '.x')
y_cur=$(hyprctl -j cursorpos | jq '.y')
# Ignore position
x_cur=$(( x_cur - x_pos))
y_cur=$(( y_cur - y_pos))
# Limiting
# Multiply before dividing to avoid losing precision due to integer division
max_x=$((x_mon - 5 - 7 * $desc_width)) #offset of 5 for gaps
max_y=$((y_mon - 5 - 60 * ${#descriptions_arr[@]} )) #offset of 15 for gaps
x_cur=$((x_cur - x_offset))
y_cur=$((y_cur - y_offset))
#
x_cur=$(( x_cur < min_x ? min_x : ( x_cur > max_x ? max_x :  x_cur)))
y_cur=$(( y_cur < min_y ? min_y : ( y_cur > max_y ? max_y :  y_cur)))


pos="window {location: north west; x-offset: ${x_cur}px; y-offset: ${y_cur}px;}" #! I just Used the old pos function
# -----------------------------------------------------------------------------------
description=$(echo "$descriptions" | rofi -dmenu -config "${roconf}" -theme-str "window {width: ${desc_width}ch;} ${pos}")

if [ -n "${description}" ]; then
    pactl set-default-sink "${sinks[${description}]}" &&
        notify-send --icon=notification-audio-volume-high "Default Audio Sink" "${description}" ||
        notify-send --icon=dialog-error "Couldn't set default audio sink!"
else
    echo "No sink selected. Default audio sink unchanged."
fi

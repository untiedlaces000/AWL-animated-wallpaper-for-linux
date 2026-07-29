#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="$HOME/.config/my_live_wallpaper"
CONFIG_FILE="$CONFIG_DIR/config"

OUTPUT_IMAGE="$HOME/Pictures/awlscreen/awl_fallback.png"
RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')

mkdir -p "$CONFIG_DIR"
[ ! -f "$CONFIG_FILE" ] && echo "VIDEO_PATH=" > "$CONFIG_FILE"
source "$CONFIG_FILE"

if [ "$1" == "--gui" ]; then
    NEW_VIDEO=$(zenity --file-selection --title="Select Live Wallpaper Video" --file-filter="Videos | *.mp4 *.mkv *.mov")
    if [ -n "$NEW_VIDEO" ]; then
        echo "VIDEO_PATH=\"$NEW_VIDEO\"" > "$CONFIG_FILE"
        VIDEO_PATH="$NEW_VIDEO"
    else
        exit 0
    fi
fi

if [ "$1" == "--daemon" ]; then
    while true; do
        sleep 7200
        sync && echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1
        bash "$0" > /dev/null 2>&1
    done
    exit 0
fi

if [ -z "$VIDEO_PATH" ] || [ ! -f "$VIDEO_PATH" ]; then
    zenity --error --text="holy moly i dont have a video to play as wallpaper. pls run the awl config shortcut or run ./awlscreen.sh --gui in the terminal"
    exit 1
fi

pkill -f xwinwrap
ffmpeg -y -ss 00:00:00 -i "$VIDEO_PATH" -vframes 1 -q:v 2 "$OUTPUT_IMAGE" > /dev/null 2>&1
gsettings set org.gnome.desktop.background picture-uri "file://$OUTPUT_IMAGE"
gsettings set org.gnome.desktop.background picture-uri-dark "file://$OUTPUT_IMAGE"
gsettings set org.gnome.desktop.background picture-options 'zoom'
xwinwrap -fdt -ni -b -g $RESOLUTION -- mpv -wid WID --loop --no-audio --panscan=1.0 "$VIDEO_PATH" &


#!/bin/bash
CONFIG_DIR="/home/alan/.config/a-wallpaper-lite"
CONFIG_FILE="$CONFIG_DIR/config"
TIMESTAMP=$(date +%s)
OUTPUT_IMAGE="$HOME/Pictures/a-wallpaper-lite/awl_fallback_${TIMESTAMP}.png"

mkdir -p "$CONFIG_DIR"
[ ! -f "$CONFIG_FILE" ] && echo "VIDEO_PATH=" > "$CONFIG_FILE"
source "$CONFIG_FILE"

DESKTOP_ENV=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')
if [ "$1" == "--gui" ]; then
    NEW_VIDEO=$(zenity --file-selection --title="Select Wayland Live Wallpaper" --file-filter="Videos | *.mp4 *.mkv *.mov")
    if [ -n "$NEW_VIDEO" ]; then
        echo "VIDEO_PATH=\"$NEW_VIDEO\"" > "$CONFIG_FILE"
        VIDEO_PATH="$NEW_VIDEO"
        pkill -f mpvpaper
        MY_PID=$$
        for pid in $(pgrep -f "awlscreen.sh"); do
            [ "$pid" != "$MY_PID" ] && kill "$pid" 2>/dev/null
        done

        mkdir -p "$HOME/Pictures/a-wallpaper-lite"
        rm -f "$HOME/Pictures/a-wallpaper-lite"/awl_fallback_*.png
    else
        exit 0
    fi
fi

if [ -z "$VIDEO_PATH" ] || [ ! -f "$VIDEO_PATH" ]; then
    zenity --error --text="holy moly i dont have a video to play as wallpaper. pls run the awl config shortcut or run ./awlscreenwayland.sh --gui in the terminal"
    exit 1
fi
pkill -f mpvpaper
mkdir -p "$(dirname "$OUTPUT_IMAGE")"
ffmpeg -y -ss 00:00:00 -i "$VIDEO_PATH" -vframes 1 -q:v 2 "$OUTPUT_IMAGE" > /dev/null 2>&1
if [[ "$DESKTOP_ENV" == *"gnome"* ]]; then
    gsettings set org.gnome.desktop.background picture-uri "file://$OUTPUT_IMAGE" 2>/dev/null
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$OUTPUT_IMAGE" 2>/dev/null
    gsettings set org.gnome.desktop.background picture-options 'zoom' 2>/dev/null
else
    gsettings set org.gnome.desktop.background picture-uri "file://$OUTPUT_IMAGE" 2>/dev/null 2>&1
    MONITOR=$(mpvpaper -d | head -n 1)
    [ -z "$MONITOR" ] && MONITOR="*"
    mpvpaper -f -l background -o "no-audio loop panscan=1.0 --input-default-bindings=no --input-vo-keyboard=no" "$MONITOR" "$VIDEO_PATH"
fi


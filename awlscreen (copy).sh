#!/bin/bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
CONFIG_DIR="$HOME/.config/my_live_wallpaper"
CONFIG_FILE="$CONFIG_DIR/config"

TIMESTAMP=$(date +%s)
OUTPUT_IMAGE="$HOME/Pictures/a-wallpaper-lite/awl_fallback_${TIMESTAMP}.png"
RESOLUTION=$(xdpyinfo | grep dimensions | awk '{print $2}')

CURRENT_DESKTOP=$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')

mkdir -p "$CONFIG_DIR"
[ ! -f "$CONFIG_FILE" ] && echo "VIDEO_PATH=" > "$CONFIG_FILE"
source "$CONFIG_FILE"

kill_video_instances() {
    pkill -f xwinwrap
    pkill -f "mpv.*--title=KDE_Wallpaper_Engine"
}

if [ "$1" == "--gui" ]; then
    NEW_VIDEO=$(zenity --file-selection --title="Select Live Wallpaper Video" --file-filter="Videos | *.mp4 *.mkv *.mov")
    if [ -n "$NEW_VIDEO" ]; then
        echo "VIDEO_PATH=\"$NEW_VIDEO\"" > "$CONFIG_FILE"
        VIDEO_PATH="$NEW_VIDEO"

        kill_video_instances
        pkill -f "bash.*awlscreen.sh"
        mkdir -p "$HOME/Pictures/a-wallpaper-lite"
        rm -f "$HOME/Pictures/a-wallpaper-lite"/awl_fallback_*.png
        sync && echo 1 | sudo tee /proc/sys/vm/drop_caches > /dev/null 2>&1
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

kill_video_instances

mkdir -p "$(dirname "$OUTPUT_IMAGE")"
ffmpeg -y -ss 00:00:00 -i "$VIDEO_PATH" -vframes 1 -q:v 2 "$OUTPUT_IMAGE" > /dev/null 2>&1

if [[ "$CURRENT_DESKTOP" == *"kde"* ]]; then
    qdbus org.kde.plasmashell /PlasmaShell org.kde.Plasmashell.evaluateScript "
        var allDesktops = desktops();
        for (var i=0; i<allDesktops.length; i++) {
            var d = allDesktops[i];
            d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
            d.writeConfig('Image', 'file://$OUTPUT_IMAGE');
        }
    " 2>/dev/null
else
    gsettings set org.gnome.desktop.background picture-uri "file://$OUTPUT_IMAGE"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$OUTPUT_IMAGE"
    gsettings set org.gnome.desktop.background picture-options 'zoom'
fi

start_video_engine() {
    if [[ "$CURRENT_DESKTOP" == *"kde"* ]]; then
        mpv --no-audio --loop --title="KDE_Wallpaper_Engine" --no-border --geometry=100%x100% --x11-name="desktop" --keep-open=yes "$VIDEO_PATH" &
    else
        xwinwrap -fdt -ni -b -g $RESOLUTION -- mpv -wid WID --loop --no-audio --panscan=1.0 "$VIDEO_PATH" &
    fi
}

start_video_engine

(
STATUS_VAR=0 

while true; do
    if [ "$STATUS_VAR" -eq 0 ]; then
        sleep 5
    else
        sleep 2
    fi

    ACTIVE_WINDOW_ID=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $NF}')

    SHOULD_STOP=false

    if [ "$ACTIVE_WINDOW_ID" != "0x0" ] && [ -n "$ACTIVE_WINDOW_ID" ]; then
        W_STATE=$(xprop -id "$ACTIVE_WINDOW_ID" _NET_WM_STATE 2>/dev/null)
        
        if echo "$W_STATE" | grep -q "FULLSCREEN" || echo "$W_STATE" | grep -q "MAXIMIZED"; then
            SHOULD_STOP=true
        fi
    fi

    if [ "$SHOULD_STOP" = true ] && [ "$STATUS_VAR" -eq 0 ]; then     
        STATUS_VAR=1
        kill_video_instances
    elif [ "$SHOULD_STOP" = false ] && [ "$STATUS_VAR" -eq 1 ]; then 
        STATUS_VAR=0
        start_video_engine
    fi
done
) </dev/null >/dev/null 2>&1 &


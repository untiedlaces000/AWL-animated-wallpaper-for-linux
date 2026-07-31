#!/bin/bash

#need this so it can do a folder check or sum shi
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

#auto installer for awl yippee
echo "A WALLPAPER LITE NEEDS TO BE IN YOUR HOME FOLDER"
echo ""
echo "::::::::::::::::::::::::::::::::::"
echo "garbage a wallpaper lite installer"
echo "::::::::::::::::::::::::::::::::::"
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "shi this installer needs root to install some things (use sudo)."
    exit 1
fi

# ai said i needed to add ts for the one of the install parts 
REAL_USER=${SUDO_USER:-$USER}
USER_HOME=$(getent passwd "$REAL_USER" | cut -d: -f6)

#theres pizza grease everywhere
FOLDERIG="$(dirname "$(readlink -f "$0")")"
EXPECTED_DIR="$USER_HOME/awlscreen"

# ts is to make it so you dont screw it up
if [ "$FOLDERIG" != "$EXPECTED_DIR" ]; then
    echo ""
    echo "ERROR: awlscreen folder is not in your home directory"
    echo "the current folder is:  $FOLDERIG"
    echo "awlscreen folder needs to be in: $EXPECTED_DIR"
    echo ""
    echo "Please move the 'awlscreen' folder to $USER_HOME/ and try again."
    exit 1
fi

#no clue how that works

echo "$FOLDERIG"
echo "copying .desktop files"

mkdir -p "$USER_HOME/.config/autostart/"
#makes the auto run folder thingy
cd "$FOLDERIG"
chmod +x awlscreen.sh
cd "$FOLDERIG/desktopfiles/"
chmod +x awl*.desktop
#makes it so you can use the thingys
cp -r awlarestart.desktop "$USER_HOME/.config/autostart/"
cp -r awlautostart.desktop "$USER_HOME/.config/autostart/"
#copys .desktop auto thingy files
cp -r awlc.desktop "$USER_HOME/.local/share/applications/"
cp -r awlstop.desktop "$USER_HOME/.local/share/applications/"
#copys the app shortcuts to shortcut place
#i like deftones :)
echo "i like deftones"
mkdir -p "$USER_HOME/Pictures"
mkdir -p "$USER_HOME/Pictures/a-wallpaper-lite"
echo "time to install things"
#shi idk how to do this next part so it would work with most distros so ima use ai sorry
install_deps() {
    # Check for distro package manager automatically
    if command -v apt-get &> /dev/null; then
        echo "Detected Debian/Ubuntu-based system (apt)..."
        apt-get update
        apt-get install -y mpv zenity git socat build-essential libx11-dev libxext-dev libxrender-dev
    elif command -v pacman &> /dev/null; then
        echo "Detected Arch-based system (pacman)..."
        pacman -Sy --noconfirm mpv zenity git socat gcc make libx11 libxext libxrender
    elif command -v dnf &> /dev/null; then
        echo "Detected Fedora/RHEL-based system (dnf)..."
        dnf install -y mpv zenity git socat gcc make libX11-devel libXext-devel libXrender-devel
    elif command -v zypper &> /dev/null; then
        echo "Detected openSUSE-based system (zypper)..."
        zypper install -y mpv zenity git socat gcc make libX11-devel libXext-devel libXrender-devel
    else
        # Manual selection fallback if detection fails
        echo "Could not auto-detect package manager."
        echo "1) Debian / Ubuntu (apt)"
        echo "2) Arch Linux (pacman)"
        echo "3) Fedora (dnf)"
	echo "4) opensuse (zypper)"
        read -p "Select your distro base [1-4]: " choice
        case $choice in
            1) apt-get update && apt-get install -y mpv zenity git socat build-essential libx11-dev libxext-dev libxrender-dev ;;
            2) pacman -Sy --noconfirm mpv zenity git socat gcc make libx11 libxext libxrender ;;
            3) dnf install -y mpv zenity git socat gcc make libX11-devel libXext-devel libXrender-devel ;;
	    4) zypper install -y mpv zenity git socat gcc make libX11-devel libXext-devel libXrender-devel ;;
            *) echo "Invalid option. Exiting dependency install."; exit 1 ;;
        esac
    fi
# downloads and builds xwinwrap from github if not already installed
    if ! command -v xwinwrap &> /dev/null; then
        echo "xwinwrap not found in repos. Building from source..."
        cd /tmp || exit
        rm -rf xwinwrap
        git clone https://github.com/ujjwal96/xwinwrap.git
        cd xwinwrap || exit
        make
        make install
        cd "$FOLDERIG" || exit
        echo "xwinwrap successfully compiled and installed!"
    else
        echo "xwinwrap is already installed."
    fi
}

install_deps

chown -R "$REAL_USER":"$REAL_USER" "$USER_HOME/.config/autostart/"
chown -R "$REAL_USER":"$REAL_USER" "$USER_HOME/.local/share/applications/"
chown -R "$REAL_USER":"$REAL_USER" "$USER_HOME/Pictures/a-wallpaper-lite"
# no more ai :)
echo "charlie kirk"
echo "ts is done now just open  awl config"
echo "look at manual install.txt if u need some debug stuff"
echo "SOME REPOS DONT HAVE XWINWRAP YOU WILL NEED TO INSTALL THIS WITH GIT AND MAKE IF THE AUTO INSTALLER DIDNT DO IT FOR YOU"
echo "you can download wallpapers from 1) motionbg 2) moewalls 3) desktophut"
update-desktop-database "$USER_HOME/.local/share/applications"
exit

#!/usr/bin/env bash
# We use pipefail for safety so errors are caught.
# We DO NOT use 'set -x' because the debug text would break the Zenity loading bar.
set -o pipefail

# Define the flag file (lives in user's home)
FLAG_FILE="$HOME/.config/firstboot-setup-done"

# 1. CHECK: If we already ran, exit immediately
if [ -f "$FLAG_FILE" ]; then
    exit 0
fi

# 2. WAIT FOR INTERNET (with UI feedback)
MAX_RETRIES=12
COUNT=0

(
    while true; do
        # We silence curl output (> /dev/null) so it doesn't break zenity
        if curl -s --head https://dl.flathub.org > /dev/null; then
            echo "100" # Done
            break
        fi
        
        if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
            echo "ERR" # Timeout
            break
        fi

        echo "# Checking internet connection... ($(( 60 - COUNT * 5 ))s remaining)"
        echo "pulse" 
        
        sleep 5
        ((COUNT++))
    done
) | zenity --progress \
    --title="Finalizing Setup" \
    --text="Waiting for network..." \
    --pulsate \
    --auto-close \
    --no-cancel \
    --width=400

# 3. HANDLE OFFLINE STATE
if ! curl -s --head https://dl.flathub.org > /dev/null; then
    if zenity --question \
        --title="Connection Failed" \
        --text="We could not connect to the internet.\n\nWithout internet, we cannot install core applications.\n\nWould you like to retry?" \
        --ok-label="Retry" \
        --cancel-label="Skip Setup"; then
        exec "$0"
    else
        touch "$FLAG_FILE"
        exit 0
    fi
fi

# 4. INSTALL APPS (SYSTEM-WIDE)
zenity --info \
    --title="Admin Rights Needed" \
    --text="We are about to install applications for ALL users.\n\nYou will be asked for your password to authorize this." \
    --width=300

APPS="app.devsuite.Ptyxis \
io.github.kolunmi.Bazaar \
com.mattjakeman.ExtensionManager \
net.nokyan.Resources \
org.mozilla.firefox \
org.gnome.TextEditor \
org.gnome.Calculator \
org.gnome.Papers \
org.gnome.baobab \
org.gnome.Snapshot \
org.gnome.Calendar \
org.gnome.Decibels \
org.gnome.Showtime \
org.gnome.Weather \
org.gnome.Music \
org.gnome.Loupe \
com.valvesoftware.Steam \
net.lutris.Lutris"

(
    echo "# Setting up Flathub Repository..."
    
    # pkexec runs the bash command as root.
    # We pipe stdout to /dev/null inside the root shell so raw flatpak text 
    # doesn't confuse Zenity, unless we want to echo specific status messages.
    pkexec bash -c "set -o pipefail; \
        flatpak remote-delete --force flathub || true; \
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo; \
        flatpak install -y --system flathub $APPS; \
        flatpak override --filesystem=xdg-config/gtk-3.0:ro; \
        flatpak override --filesystem=xdg-config/gtk-4.0:ro; \
        flatpak override --filesystem=/usr/share/fonts:ro"
    
    echo "pulse"
    echo "# Installing Applications (This may take a few minutes)..."

) | zenity --progress \
    --title="Setting up Environment" \
    --text="Installing system applications..." \
    --pulsate \
    --auto-close \
    --no-cancel \
    --width=500

# 5. FINISH
touch "$FLAG_FILE"

zenity --info \
    --title="Setup Complete" \
    --text="Your system is ready!" \
    --width=300

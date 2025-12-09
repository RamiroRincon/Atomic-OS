#!/bin/bash

# 1. Detect Dark Mode and apply it to Zenity
# We check the user's interface setting. If dark, we force the dark theme for this script.
THEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
if [[ "$THEME" == *'dark'* ]]; then
    export GTK_THEME=Adwaita:dark
    export ADW_DISABLE_PORTAL=1
fi

# 2. Define the Installation Logic
install_apps() {
    # Phase 1: Setup
    echo "10"
    echo "# Setting up App Sources..."
    # Removing '--user' makes this system-wide (requires admin password)
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    sleep 1

    # Phase 2: Terminal (Ptyxis)
    echo "30"
    echo "# Installing Terminal..."
    # Removing '--user' installs for ALL users
    if ! flatpak install -y flathub app.devsuite.Ptyxis; then
        echo "ERR: Terminal failed to install"
        exit 1
    fi

    # Phase 3: App Store (Bazaar)
    echo "70"
    echo "# Installing App Store..."
    if ! flatpak install -y flathub io.github.kolunmi.Bazaar; then
        echo "ERR: App Store failed to install"
        exit 1
    fi

    # Phase 4: Finish
    echo "100"
    echo "# Setup Complete!"
    sleep 1
}

# 3. Notify User about Password
# Since system-wide install requires auth, we warn them gently.
zenity --info \
  --title="System Setup" \
  --text="We are about to install the Terminal and App Store for ALL users.\n\nYou may be asked for your administrator password to proceed." \
  --width=300

# 4. Run the installer piped into Zenity
# The output is captured to check for errors, while progress info goes to Zenity
ERROR_LOG=$(mktemp)

install_apps 2> "$ERROR_LOG" | zenity --progress \
  --title="System Setup" \
  --text="Initializing..." \
  --percentage=0 \
  --auto-close \
  --width=400

# 5. Check result and show final dialog
if [ $? -eq 0 ]; then
    # Success
    zenity --info \
      --title="Setup Complete" \
      --text="The Terminal and App Store have been successfully installed for all users.\n\nYou can find them in your application menu." \
      --ok-label="Finish" \
      --width=300
else
    # Failure
    zenity --error \
      --title="Setup Failed" \
      --text="An error occurred during installation.\n\n$(cat $ERROR_LOG)" \
      --width=400
fi

rm -f "$ERROR_LOG"

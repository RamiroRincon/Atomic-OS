#!/bin/bash

# 1. Detect Dark Mode and apply it to Zenity
# We check the user's interface setting. If dark, force Adwaita-dark for Zenity.
THEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
if [[ "$THEME" == *'dark'* ]]; then
    export GTK_THEME=Adwaita:dark
    export ADW_DISABLE_PORTAL=1
fi

# 2. Define the Installation Logic with Smart Checks
install_apps() {
    # Phase 1: Setup Sources
    echo "10"
    echo "# Setting up App Sources..."
    
    # Add Flathub (System-Wide)
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    
    # Fix the "Offline" bug by forcing a catalog sync
    echo "# Syncing App Catalog..."
    flatpak update --appstream -y
    sleep 1

    # Phase 2: Terminal (Ptyxis)
    # Silently check if already installed to avoid re-downloading/output noise
    if ! flatpak list --app --columns=application | grep -q "app.devsuite.Ptyxis"; then
        echo "30"
        echo "# Installing Terminal..."
        if ! flatpak install -y flathub app.devsuite.Ptyxis; then
            echo "ERR: Terminal failed to install"
            exit 1
        fi
    else
        echo "30"
        echo "# Terminal already installed... You can delete this file, everything is already set up."
        sleep 1
    fi

    # Phase 3: App Store (Bazaar)
    if ! flatpak list --app --columns=application | grep -q "io.github.kolunmi.Bazaar"; then
        echo "70"
        echo "# Installing App Store..."
        if ! flatpak install -y flathub io.github.kolunmi.Bazaar; then
            echo "ERR: App Store failed to install"
            exit 1
        fi

        echo "# Configuring App Store..."
        flatpak run --command=gsettings io.github.kolunmi.Bazaar \
            set io.github.kolunmi.Bazaar show-flathub-only true
    
    else
        echo "70"
        echo "# App Store already installed... You can delete this file, everything is already set up."
        sleep 1
    fi

    # Phase 4: Finish
    echo "100"
    echo "# Setup Complete!"
    sleep 1
}

# 3. Notify User about Password (since it's system-wide)
zenity --info \
  --title="System Setup" \
  --text="We are checking system applications for ALL users.\n\nYou may be asked for your administrator password to proceed." \
  --width=300

# 4. Run the installer piped into Zenity
# We capture errors to a log file, but pipe progress commands to Zenity
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
      --text="The Terminal and App Store are ready for use. You can delete this file now." \
      --ok-label="Finish" \
      --width=300
else
    # Failure
    zenity --error \
      --title="Setup Failed" \
      --text="An error occurred during setup.\n\n$(cat $ERROR_LOG)" \
      --width=400
fi

rm -f "$ERROR_LOG"

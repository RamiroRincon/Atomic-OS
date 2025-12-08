#!/usr/bin/env bash
set -ox pipefail

# Check if we have already run
if [ -f /var/lib/flatpak-firstboot-done ]; then
    exit 0
fi

echo "Waiting for internet connection..."

# Set a max attempt counter to prevent infinite boot hang

MAX_RETRIES=60
COUNT=0
until curl -s --head https://dl.flathub.org > /dev/null; do
    if [ "$COUNT" -ge "$MAX_RETRIES" ]; then
        echo "Internet not reachable after 5 minutes. Skipping Flatpak setup."
        exit 1
    fi
    sleep 5
    ((COUNT++))
done

echo "Running First Boot Setup..."

# 1. Force Full Flathub
flatpak remote-delete --force flathub || true
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 2. Install Core Apps (System-wide)
echo "Installing Core Apps..."
flatpak install -y flathub \
    app.devsuite.Ptyxis \
    io.github.kolunmi.Bazaar \
    flathub com.mattjakeman.ExtensionManager \
    org.mozilla.firefox \
    org.gnome.TextEditor \
    org.gnome.Calculator \
    org.gnome.Papers \
    org.gnome.Loupe

# 3. Install Gaming Apps & Extra functionality
echo "Installing Gaming Apps..."
flatpak install -y flathub \
    com.valvesoftware.Steam \
    net.lutris.Lutris

# 4. Apply Integration
flatpak override --filesystem=xdg-config/gtk-3.0:ro
flatpak override --filesystem=xdg-config/gtk-4.0:ro
flatpak override --filesystem=/usr/share/fonts:ro 

# 5. Mark as done
touch /var/lib/flatpak-firstboot-done
echo "First Boot Setup Complete."

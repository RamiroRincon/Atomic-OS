#!/usr/bin/env bash

# Check if we have already run
if [ -f /var/lib/flatpak-firstboot-done ]; then
    exit 0
fi

echo "Running First Boot Setup..."

# 1. Add Flathub Remote
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# 2. Install Core Apps (Removable by user later)
# - Text Editor
# - Calculator
# - Evince (Documents)
# - Loupe (Images)
flatpak install -y flathub \
    org.gnome.TextEditor \
    org.gnome.Calculator \
    org.gnome.Evince \
    org.gnome.Loupe

# 3. Apply Integration (Theme/Fonts)
# Allow all Flatpaks to read system config (GTK themes/fonts)
flatpak override --filesystem=xdg-config/gtk-3.0:ro
flatpak override --filesystem=xdg-config/gtk-4.0:ro
flatpak override --filesystem=~/.icons:ro
flatpak override --filesystem=~/.themes:ro

# Force Flatpaks to use host fonts
flatpak override --filesystem=/usr/share/fonts:ro 
flatpak override --filesystem=~/.local/share/fonts:ro

# 4. Mark as done so it doesn't run next boot
touch /var/lib/flatpak-firstboot-done

echo "First Boot Setup Complete."

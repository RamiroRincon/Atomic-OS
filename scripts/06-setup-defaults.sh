#!/bin/bash

set -ouex pipefail

echo "Applying custom GNOME defaults..."

# Define the override file path
OVERRIDE_FILE="/usr/share/glib-2.0/schemas/zz01-custom-settings.gschema.override"

# Create the override file with your settings
cat <<EOF > "$OVERRIDE_FILE"
# ----------------------------------
# FILES (NAUTILUS) SETTINGS
# ----------------------------------
[org.gnome.nautilus.preferences]
default-folder-viewer='list-view'
sort-directories-first=true

[org.gnome.nautilus.list-view]
default-zoom-level='small'

[org.gtk.Settings.FileChooser]
sort-directories-first=true

# ----------------------------------
# POWER SETTINGS
# ----------------------------------
[org.gnome.settings-daemon.plugins.power]
power-profile='performance'
sleep-inactive-ac-type='nothing'

# ----------------------------------
# INTERFACE & THEME
# ----------------------------------
[org.gnome.desktop.interface]
color-scheme='prefer-dark'
show-battery-percentage=true
enable-hot-corners=false

# ----------------------------------
# WINDOWS & WORKSPACES
# ----------------------------------
[org.gnome.mutter]
# Disable dynamic workspaces to enforce a fixed number
dynamic-workspaces=false

[org.gnome.desktop.wm.preferences]
# Add buttons
button-layout='appmenu:minimize,maximize,close'
# Set fixed number of workspaces
num-workspaces=2

# ----------------------------------
# INPUT (MOUSE/TRACKPAD)
# ----------------------------------
[org.gnome.desktop.peripherals.touchpad]
tap-to-click=true

[org.gnome.desktop.peripherals.mouse]
natural-scroll=false
accel-profile='flat'

# ----------------------------------
# PRIVACY / ANNOYANCES
# ----------------------------------
[org.gnome.desktop.privacy]
remember-recent-files=false

[org.gnome.software]
download-updates=false
EOF

# ----------------------------------
# APPLY CHANGES
# ----------------------------------
echo "Compiling GSettings schemas..."
glib-compile-schemas /usr/share/glib-2.0/schemas/

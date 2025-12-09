#!/usr/bin/env bash
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
# Set view as "list"
default-folder-viewer='list-view'
# Sort directories first
sort-directories-first=true

[org.gnome.nautilus.list-view]
# Set zoom level to "small"
default-zoom-level='small'

[org.gtk.Settings.FileChooser]
# Sort directories first
sort-directories-first=true

# ----------------------------------
# POWER SETTINGS
# ----------------------------------
[org.gnome.settings-daemon.plugins.power]
# Set power profile to "Performance"
power-profile='performance'
# Prevent sleep when inactive and connected to power (I think)
sleep-inactive-ac-type='nothing'

# ----------------------------------
# INTERFACE & THEME
# ----------------------------------
[org.gnome.desktop.interface]
# Set Dark Mode
color-scheme='prefer-dark'
# Show battery percentage
show-battery-percentage=true
# Disable hot corners
enable-hot-corners=false

# ----------------------------------
# WINDOWS & WORKSPACES
# ----------------------------------
[org.gnome.mutter]
# Disable dynamic workspaces to enforce a fixed number
dynamic-workspaces=false
# Center new windows by default (macOS/Windows behavior)
center-new-windows=true

[org.gnome.desktop.wm.preferences]
# Add buttons to windows
button-layout='appmenu:minimize,maximize,close'
# Set fixed number of workspaces
num-workspaces=2

# ----------------------------------
# INPUT (MOUSE/TRACKPAD)
# ----------------------------------
[org.gnome.desktop.peripherals.touchpad]
# Enable Tap-to-Click
tap-to-click=true

[org.gnome.desktop.peripherals.mouse]
# Disable natural scroll
natural-scroll=false
# Disable mouse acceleration
accel-profile='flat'

# ----------------------------------
# DESKTOP ICONS (REQUIRES DING EXTENSION)
# ----------------------------------
# These settings configure the Desktop Icons NG extension 
[org.gnome.shell.extensions.ding]
# Show the "home" folder on the Desktop
show-home=true
# Show the "trash" folder on the Desktop
show-trash=true
# Show external drives on the Desktop
show-volumes=false

# ----------------------------------
# EXTENSIONS
# ----------------------------------
[org.gnome.shell]
# Enable Dash-to-Dock and Blur my Shell
enabled-extensions=['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx']
# Explicitly disable the Fedora background logo
disabled-extensions=['background-logo@fedorahosted.org']

# ----------------------------------
# LOGIN SCREEN (GDM)
# ----------------------------------
[org.gnome.login-screen]
# Remove the logo from the login screen
logo=''

# ----------------------------------
# PRIVACY / ANNOYANCES
# ----------------------------------
[org.gnome.desktop.privacy]
# Disable "Remember recent files"
remember-recent-files=false
[org.gnome.software]
# Disable auto-download of updates (not needed since we're using ostree)
download-updates=false

EOF

# ----------------------------------
# APPLY CHANGES
# ----------------------------------
echo "Compiling GSettings schemas..."
glib-compile-schemas /usr/share/glib-2.0/schemas/

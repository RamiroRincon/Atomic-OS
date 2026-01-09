#!/usr/bin/env bash
set -ouex pipefail

echo "Applying custom system defaults..."

# ----------------------------------
# 1. FIX POWER PROFILE (System-Wide)
# ----------------------------------
# Force "Performance" mode via Tuned (Fedora 41+)
mkdir -p /etc/tuned
echo "throughput-performance" > /etc/tuned/active_profile

# ----------------------------------
# 2. CONFIGURE DCONF PROFILE
# ----------------------------------
# This tells GNOME to look at a "local" database for defaults
mkdir -p /etc/dconf/profile
cat <<EOF > /etc/dconf/profile/user
user-db:user
system-db:local
EOF

# ----------------------------------
# 3. SET DEFAULTS IN 'LOCAL' DB
# ----------------------------------
mkdir -p /etc/dconf/db/local.d

# We write a keyfile here. Note that section headers use slashes (/), not dots.
cat <<EOF > /etc/dconf/db/local.d/00-atomic-defaults

# --- NAUTILUS (FILES) ---
[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'
sort-directories-first=true

[org/gnome/nautilus/list-view]
default-zoom-level='small'

[org/gtk/settings/file-chooser]
sort-directories-first=true

# --- INTERFACE & THEME ---
[org/gnome/desktop/interface]
color-scheme='prefer-dark'
show-battery-percentage=true
enable-hot-corners=false
font-name='SF Pro Display 11'
document-font-name='SF Pro Text 11'
monospace-font-name='SF Mono 10'
titlebar-font='SF Pro Display Bold 11'

# --- WORKSPACES ---
[org/gnome/mutter]
dynamic-workspaces=false
center-new-windows=true

[org/gnome/desktop/wm/preferences]
num-workspaces=2
button-layout='appmenu:minimize,maximize,close'

# --- INPUT ---
[org/gnome/desktop/peripherals/touchpad]
tap-to-click=true

[org/gnome/desktop/peripherals/mouse]
natural-scroll=false
accel-profile='flat'

# --- DESKTOP ICONS ---
[org/gnome/shell/extensions/ding]
show-home=true
show-trash=true
show-volumes=false

# --- DASH TO DOCK ---
[org/gnome/shell/extensions/dash-to-dock]
transparency-mode='FIXED'
background-opacity=0.25
click-action='focus-minimize-or-previews'
show-apps-at-top=true
animate-show-apps=true
disable-overview-on-startup=true
dash-max-icon-size=64

# --- EXTENSIONS ---
[org/gnome/shell]
enabled-extensions=['dash-to-dock@micxgx.gmail.com']
disabled-extensions=['background-logo@fedorahosted.org']

# --- LOGIN SCREEN ---
[org/gnome/login-screen]
logo=''

# --- PRIVACY & UPDATES ---
[org/gnome/desktop/privacy]
remember-recent-files=false

[org/gnome/software]
download-updates=false

EOF

# ----------------------------------
# 4. UPDATE DCONF DATABASE
# ----------------------------------
# This compiles the text files into the binary database GNOME reads
echo "Updating dconf..."
dconf update

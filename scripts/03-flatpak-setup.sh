#!/usr/bin/env bash
set -ouex pipefail

echo "Setting up Firstboot Setup Wizard..."

# 1. Install the script to /usr/bin
# We use -m 0755 so it is executable by everyone
install -m 0755 /tmp/assets/firstboot-flatpaks.sh /usr/bin/firstboot-flatpaks

# 2. Create the Autostart Entry
# This makes the script run when ANY user logs into the graphical desktop.
mkdir -p /etc/xdg/autostart

cat <<EOF > /etc/xdg/autostart/firstboot-wizard.desktop
[Desktop Entry]
Type=Application
Name=Setup Wizard
Comment=Installs core apps on first login
Exec=/usr/bin/firstboot-flatpaks
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

echo "Wizard setup complete."

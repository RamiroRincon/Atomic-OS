#!/bin/bash
set -ouex pipefail

echo "Setting up Firstboot Flatpak Service..."

# Install the script to /usr/bin with executable permissions (0755)
install -m 0755 /tmp/assets/firstboot-flatpaks.sh /usr/bin/firstboot-flatpaks.sh

# Install the service file to systemd directory with read permissions (0644)
install -m 0644 /tmp/assets/firstboot-flatpaks.service /usr/lib/systemd/system/firstboot-flatpaks.service

# Enable the service so it runs on next boot
systemctl enable firstboot-flatpaks.service

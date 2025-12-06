#!/usr/bin/env bash
set -eox pipefail

# Copy the script to bin and make executable
cp /tmp/assets/firstboot-flatpaks.sh /usr/bin/firstboot-flatpaks.sh
chmod +x /usr/bin/firstboot-flatpaks.sh

# Copy the service file
cp /tmp/assets/firstboot-flatpaks.service /usr/lib/systemd/system/

# Enable the service
systemctl enable firstboot-flatpaks.service

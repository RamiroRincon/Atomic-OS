#!/usr/bin/env bash
set -eox pipefail

##### GNOME SETUP #####

# Install GNOME desktop
rpm-ostree install \
    @gnome-desktop \
    gdm

# Force GDM Wayland-only
mkdir -p /etc/gdm
cat >/etc/gdm/custom.conf <<EOF
[daemon]
WaylandEnable=true
EOF

# Enable GDM + graphical default via presets
mkdir -p /etc/systemd/system-preset
cat >/etc/systemd/system-preset/90-gdm.preset <<EOF
enable gdm.service
set-default graphical.target
EOF

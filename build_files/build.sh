#!/usr/bin/env bash
set -eox pipefail

##### GNOME SETUP #####

# Install GNOME desktop
rpm-ostree install \
    gdm \
    gnome-shell \
    mutter \
    gnome-session \
    gnome-settings-daemon \
    gnome-control-center \
    xdg-desktop-portal-gnome \
    adwaita-icon-theme \
    gsettings-desktop-schemas

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

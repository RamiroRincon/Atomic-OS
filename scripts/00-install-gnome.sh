#!/usr/bin/env bash
set -eox pipefail

# Install Core GNOME
# specific packages to ensure minimal bootable desktop
rpm-ostree install \
    gdm \
    gnome-shell \
    nautilus \
    mutter \
    gnome-session \
    gnome-settings-daemon \
    gnome-control-center \
    xdg-desktop-portal-gnome \
    xdg-user-dirs-gtk \
    adwaita-icon-theme \
    gsettings-desktop-schemas \
    gnome-backgrounds \
    gnome-backgrounds-extras

# GDM Configuration (Wayland)
mkdir -p /etc/gdm
cat >/etc/gdm/custom.conf <<EOF
[daemon]
WaylandEnable=true
EOF

# Enable Services
systemctl enable gdm.service
systemctl set-default graphical.target

#!/usr/bin/env bash
set -eox pipefail

# Install Core GNOME
# Only specific packages to ensure minimal bootable desktop
rpm-ostree install \
    gdm \
    gnome-shell \
    gnome-session \
    gnome-settings-daemon \
    gnome-control-center \
    gnome-backgrounds \
    gnome-backgrounds-extras \
    gnome-initial-setup \
    nautilus \
    mutter \
    xdg-desktop-portal-gnome \
    xdg-user-dirs-gtk \
    adwaita-icon-theme \
    gsettings-desktop-schemas

# Install core GNOME Extensions
rpm-ostree install \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-blur-my-shell \

# Install aditional RPM packages
rpm-ostree install \
    gamemode \
    gamescope \
    mangohud \
    sushi \
    ffmpeg \
    mesa-va-drivers-freeworld \
    mesa-vdpau-drivers-freeworld

# GDM Configuration (Wayland)
mkdir -p /etc/gdm
cat >/etc/gdm/custom.conf <<EOF
[daemon]
WaylandEnable=true
InitialSetupEnable=True
EOF

# Enable Services
systemctl enable gdm.service
systemctl set-default graphical.target

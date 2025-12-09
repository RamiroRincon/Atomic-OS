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

# Install Flatpak REF and Flathub
flatpak remote-add --if-not-exists \
    flathub \
    https://flathub.org/repo/flathub.flatpakrepo

# Install Terminal with Flatpak (This is only temporary until I can find a better way to do it)
flatpak install -y \
    app.devsuite.Ptyxis 

# Enable RPM Fusion Repositories
rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Install Multimedia Codecs & Drivers
rpm-ostree install \
    gstreamer1-plugin-libav \
    gstreamer1-plugins-bad-free-extras \
    gstreamer1-plugins-ugly \
    gstreamer1-vaapi

# Install core GNOME Extensions
rpm-ostree install \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-blur-my-shell

# Install aditional RPM packages
rpm-ostree install \
    gamemode \
    gamescope \
    mangohud \
    sushi \
    hplip

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

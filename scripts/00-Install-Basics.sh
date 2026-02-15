##| #!/usr/bin/env bash
##| set -eox pipefail
##| 
##| # 1. Install KDE Plasma
##| # Only specific packages to ensure minimal bootable desktop
##| rpm-ostree install \
##|     sddm \
##|     plasma-desktop \
##|     plasma-nm \
##|     plasma-pa \
##|     plasma-systemmonitor \
##|     plasma-workspace-wayland \
##|     kinfocenter \
##|     kwayland-integration \
##|     kdegraphics-thumbnailers \
##|     dolphin \
##|     ark \
##|     konsole \
##|     spectacle \
##|     xdg-desktop-portal-kde \
##|     bluedevil
##| 
##| # 2. Enable RPM Fusion Repositories
##| rpm-ostree install \
##|     https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
##|     https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
##| 
##| # 3. Install Multimedia Codecs, Drivers & Extras
##| rpm-ostree install \
##|     gstreamer1-plugin-libav \
##|     gstreamer1-plugins-bad-free-extras \
##|     gstreamer1-plugins-ugly \
##|     gstreamer1-vaapi \
##|     kdialog \
##|     flatpak
##| 
##| # 4. Install aditional packages
##| rpm-ostree install \
##|     gamemode \
##|     gamescope \
##|     mangohud \
##|     kfind \
##|     hplip
##| 
##| # 5. SDDM Configuration (The KDE Display Manager)
##| # SDDM handles the login screen. We ensure it's set for Wayland.
##| mkdir -p /etc/sddm.conf.d
##| cat >/etc/sddm.conf.d/wayland.conf <<EOF
##| [General]
##| DisplayServer=wayland
##| GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell
##| EOF
##| 
##| # Enable Services
##| systemctl enable sddm.service
##| systemctl set-default graphical.target
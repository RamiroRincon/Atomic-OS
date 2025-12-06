#!/usr/bin/env bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

# systemctl enable podman.socket

####### MY CONFIGURATION STARTS HERE #######

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

# Enable the display manager
systemctl enable gdm.service

# Set graphical target as default
systemctl set-default graphical.target

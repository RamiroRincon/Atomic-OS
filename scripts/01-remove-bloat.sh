#!/usr/bin/env bash
set -eox pipefail

# List of RPMs to remove
# We use 'override remove' because they are likely part of the base layer
rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    gnome-tour \
    gnome-clocks \
    gnome-maps \
    gnome-weather \
    gnome-contacts \
    gnome-calculator \
    gnome-characters \
    gnome-logs \
    gnome-font-viewer \
    gnome-disk-utility \
    evince \
    loupe \
    yelp \
    htop \
    nvtop \
    fedora-media-writer

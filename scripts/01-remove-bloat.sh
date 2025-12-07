#!/usr/bin/env bash
set -eox pipefail

# Define the list as a standard string or array
PACKAGES=(
  firefox
  firefox-langpacks
  gnome-tour
  gnome-clocks
  gnome-maps
  gnome-weather
  gnome-contacts
  gnome-calculator
  gnome-characters
  gnome-logs
  gnome-font-viewer
  gnome-disk-utility
  loupe
  snapshot
  simple-scan
  totem
  yelp
  htop
  nvtop
  fedora-bookmarks
  fedora-chromium-config
  malcontent-control
)

# Convert the array to a space-separated string and run ONE command
echo "Removing packages..."
rpm-ostree override remove "${PACKAGES[@]}"

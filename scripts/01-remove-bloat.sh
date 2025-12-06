#!/usr/bin/env bash
set -eox pipefail

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
  baobab
  evince
  eog
  loupe
  snapshot
  simple-scan
  totem
  yelp
  htop
  nvtop
  fedora-media-writer
)

for pkg in "${PACKAGES[@]}"; do
    rpm-ostree override remove "$pkg" || true
done

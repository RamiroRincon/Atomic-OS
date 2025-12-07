#!/usr/bin/env bash
set -eox pipefail

# Define the list as a standard string or array
PACKAGES=(
  firefox
  firefox-langpacks
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

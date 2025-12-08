#!/usr/bin/env bash
set -eox pipefail

# 1. Define your wish list of packages to remove
WANT_TO_REMOVE=(
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
  epiphany-runtime
)

# 2. Filter the list: Create a new array containing ONLY packages that actually exist
ACTUALLY_INSTALLED=()

echo "Checking package availability..."
for pkg in "${WANT_TO_REMOVE[@]}"; do
    if rpm -q "$pkg" &>/dev/null; then
        echo "Found: $pkg"
        ACTUALLY_INSTALLED+=("$pkg")
    else
        echo "Skipping: $pkg (not present in image)"
    fi
done

# 3. Run the removal command only on the valid list
if [ ${#ACTUALLY_INSTALLED[@]} -gt 0 ]; then
    echo "Removing ${#ACTUALLY_INSTALLED[@]} packages..."
    rpm-ostree override remove "${ACTUALLY_INSTALLED[@]}"
else
    echo "Nothing to remove!"
fi

# 4. Remove the lingering Mozilla folder from the skeleton directory
rm -rf /etc/skel/.mozilla

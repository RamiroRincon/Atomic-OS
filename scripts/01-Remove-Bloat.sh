#!/usr/bin/env bash
set -eox pipefail

# 1. Define your wish list of packages to remove
# (We are NOT touching libav* or codecs anymore)
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
  gnome-extensions-app
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

# 2. Filter the list
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

# 3. Simple Removal (No Swap, No Conflicts)
if [ ${#ACTUALLY_INSTALLED[@]} -gt 0 ]; then
    echo "Removing ${#ACTUALLY_INSTALLED[@]} packages..."
    rpm-ostree override remove "${ACTUALLY_INSTALLED[@]}"
else
    echo "Nothing to remove!"
fi

# 4. Cleanup
rm -rf /etc/skel/.mozilla

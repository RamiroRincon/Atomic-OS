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

# 3. UNIFIED REMOVAL & SWAP
# We combine the "Bloat Removal" and the "Codec Swap" into ONE command.
# This prevents dependency conflicts because the solver sees the final state immediately.

if [ ${#ACTUALLY_INSTALLED[@]} -gt 0 ]; then
    echo "Executing Unified Removal and Codec Swap..."
    rpm-ostree override remove \
        "${ACTUALLY_INSTALLED[@]}" \
        libavcodec-free \
        libavfilter-free \
        libavformat-free \
        libavutil-free \
        libpostproc-free \
        libswresample-free \
        libswscale-free \
        --install ffmpeg
else
    echo "Nothing to remove? This shouldn't happen. Running swap anyway."
    rpm-ostree override remove \
        libavcodec-free \
        libavfilter-free \
        libavformat-free \
        libavutil-free \
        libpostproc-free \
        libswresample-free \
        libswscale-free \
        --install ffmpeg
fi

# 4. Cleanup Firefox folder
rm -rf /etc/skel/.mozilla

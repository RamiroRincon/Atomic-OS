#!/usr/bin/env bash
set -eox pipefail

# 1. Define your wish list of packages to remove
# (We are NOT touching libav* or codecs anymore)
WANT_TO_REMOVE=(
  firefox
  firefox-langpacks
  elisa-player
  khelpcenter
  kaddressbook
  korganizer
  kmail
  akonadi-import-wizard
  kcm_akonadi
  knotes
  kontact
  kmahjongg
  kmines
  ksudoku
  kpat
  kolourpaint
  gwenview
  okular
  dragon
  haruna
  htop
  nvtop
  fedora-bookmarks
  fedora-chromium-config
  google-noto-emoji-color-fonts
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

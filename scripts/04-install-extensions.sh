#!/bin/bash

set -ouex pipefail

# 1. Get current GNOME version (e.g., "46")
GNOME_VERSION=$(gnome-shell --version | cut -d ' ' -f 3 | cut -d . -f 1)
echo "Detected GNOME Version: $GNOME_VERSION"

# 2. Define the Function to install any extension by UUID
install_extension() {
    EXTENSION_UUID=$1
    echo "--- Installing: $EXTENSION_UUID ---"
    
    INSTALL_PATH="/usr/share/gnome-shell/extensions/$EXTENSION_UUID"

    # Query GNOME API for the download URL
    DOWNLOAD_URL=$(curl -s "https://extensions.gnome.org/extension-info/?uuid=$EXTENSION_UUID&shell_version=$GNOME_VERSION" | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('download_url', 'None'))")

    if [ "$DOWNLOAD_URL" == "None" ] || [ -z "$DOWNLOAD_URL" ]; then
        echo "ERROR: Could not find a compatible version of $EXTENSION_UUID for GNOME $GNOME_VERSION."
        exit 1 # Uncomment to fail the build if an extension is missing
        return
    fi

    FULL_URL="https://extensions.gnome.org$DOWNLOAD_URL"
    echo "Downloading from: $FULL_URL"

    # Download and Unzip
    mkdir -p "$INSTALL_PATH"
    curl -L "$FULL_URL" -o /tmp/extension.zip
    unzip -o /tmp/extension.zip -d "$INSTALL_PATH"
    rm /tmp/extension.zip

    # Compile Schemas (if they exist)
    if [ -d "$INSTALL_PATH/schemas" ]; then
        echo "Compiling schemas..."
        glib-compile-schemas "$INSTALL_PATH/schemas"
    fi

    # Set Permissions
    chmod -R 755 "$INSTALL_PATH"
    echo "Success!"
}

# 3. LIST OF EXTENSIONS TO INSTALL
# Add or remove UUIDs here
install_extension "dash-to-dock@micxgx.gmail.com" # Dash-to-Dock
install_extension "blur-my-shell@aunetx" # Blur my Shell
install_extension "ding@rastersoft.com" # DING

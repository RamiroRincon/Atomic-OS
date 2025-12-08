#!/bin/bash
set -ouex pipefail

# Helper function to install an extension by UUID
install_extension() {
    UUID=$1
    echo "Installing GNOME Extension: $UUID"

    # 1. Get the download URL for the latest version compatible with the current GNOME version
    # We use curl to query the API and python3 to parse the JSON response (standard on Fedora)
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$UUID" | \
        python3 -c "import sys, json; print(json.load(sys.stdin)['extensions'][0]['shell_version_map'].get('46', {}).get('pk', 'none'))")
    
    # Note: '46' above targets GNOME 46 (current stable). 
    # If the API returns 'none', we fallback to the latest available version in the map.
    if [ "$VERSION_TAG" == "none" ]; then
         VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$UUID" | \
            python3 -c "import sys, json; ext = json.load(sys.stdin)['extensions'][0]; print(max(ext['shell_version_map'].values(), key=lambda x: x['pk'])['pk'])")
    fi

    # 2. Download the extension ZIP
    wget -O "/tmp/extension.zip" "https://extensions.gnome.org/download-extension/$UUID.shell-extension.zip?version_tag=$VERSION_TAG"

    # 3. Determine the install path (Skeleton directory for new users)
    INSTALL_PATH="/etc/skel/.local/share/gnome-shell/extensions/$UUID"
    mkdir -p "$INSTALL_PATH"

    # 4. Unzip and cleanup
    unzip -q "/tmp/extension.zip" -d "$INSTALL_PATH"
    rm "/tmp/extension.zip"
    
    # 5. Fix permissions so the user owns them after copy
    chmod -R 755 "$INSTALL_PATH"
}

# --- EXTENSION LIST ---
# Add the UUIDs of the extensions you want below.
# You can find UUIDs in the "Details" section of any extension on extensions.gnome.org

# Dash to Dock (MacOS style dock)
install_extension "dash-to-dock@micxgx.gmail.com"

# Blur My Shell (Aesthetic improvement)
install_extension "blur-my-shell@aunetx"

# Logo Menu (Removes Activities button, adds logo)
install_extension "logomenu@aryan_k"

#!/bin/bash

set -ouex pipefail

echo "==> Installing GNOME extensions"

# Get GNOME Shell version
GNOME_VERSION=$(gnome-shell --version | cut -d' ' -f3 | cut -d'.' -f1)

# Function to install extension from extensions.gnome.org
install_extension() {
    local EXTENSION_ID=$1
    local EXTENSION_UUID=$2
    
    echo "Installing extension: ${EXTENSION_UUID}"
    
    # Get extension info and download URL
    local INFO_URL="https://extensions.gnome.org/extension-info/?pk=${EXTENSION_ID}&shell_version=${GNOME_VERSION}"
    local DOWNLOAD_URL=$(curl -sL "${INFO_URL}" | jq -r '.download_url')
    
    if [ -z "${DOWNLOAD_URL}" ] || [ "${DOWNLOAD_URL}" = "null" ]; then
        echo "Warning: Could not find extension ${EXTENSION_UUID} for GNOME ${GNOME_VERSION}"
        return 1
    fi
    
    # Download and install
    local TEMP_FILE="/tmp/${EXTENSION_UUID}.zip"
    curl -sL "https://extensions.gnome.org${DOWNLOAD_URL}" -o "${TEMP_FILE}"
    
    mkdir -p "/usr/share/gnome-shell/extensions/${EXTENSION_UUID}"
    unzip -q -o "${TEMP_FILE}" -d "/usr/share/gnome-shell/extensions/${EXTENSION_UUID}"
    rm "${TEMP_FILE}"
    
    echo "Installed: ${EXTENSION_UUID}"
}

# Install jq and curl for downloading extensions
dnf5 install -y jq curl unzip

# Install extensions
# Format: install_extension <extension_id> <extension_uuid>
install_extension 1648 "tweaks-system-menu@extensions.gnome-shell.fifi.org"
install_extension 3210 "tilingshell@ferrarodomenico.com"
install_extension 4998 "legacyschemeautoswitcher@joshimukul29.gmail.com"
install_extension 1065 "gsconnect@andyholmes.github.io"
install_extension 5412 "do-not-disturb-while-screen-sharing-or-recording@marcinjahn.com"
install_extension 779 "clipboard-indicator@tudmotu.com"
install_extension 6513 "boostvolume@shaquib.dev"
install_extension 701 "volume_scroller@francislavoie.github.io"

echo "==> GNOME extensions installation complete"

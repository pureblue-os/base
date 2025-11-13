#!/bin/bash

set -ouex pipefail

echo "==> Removing Bluefin/ublue branding"

# Remove Bluefin backgrounds
rm -rf /usr/share/backgrounds/bluefin
rm -rf /usr/share/backgrounds/gnome
rm -rf /usr/share/backgrounds/f42
rm -rf /usr/etc/bazaar/*bluefin*.jxl

# Remove Bluefin dconf settings
rm -f /usr/etc/dconf/db/distro.d/01-bluefin-folders
rm -f /usr/etc/dconf/db/distro.d/02-bluefin-keybindings
rm -f /usr/etc/dconf/db/distro.d/03-bluefin-ptyxis-palette
rm -f /usr/etc/dconf/db/distro.d/04-bluefin-logomenu-extension
rm -f /usr/etc/dconf/db/distro.d/05-bluefin-searchlight-extension
rm -f /usr/etc/dconf/db/distro.d/locks/01-bluefin-locked-settings

# Remove ublue pixmaps
rm -f /usr/share/pixmaps/ublue-discourse.svg
rm -f /usr/share/pixmaps/ublue-docs.svg
rm -f /usr/share/pixmaps/ublue-update.svg

# Remove ublue logos from GNOME extensions
rm -f /usr/share/gnome-shell/extensions/logomenu@aryan_k/Resources/ublue-logo-symbolic.svg
rm -f /usr/share/gnome-shell/extensions/logomenu@aryan_k/Resources/ublue-logo.svg

# Remove Bluefin bazaar launcher
rm -f /usr/bin/bluefin-bazaar-launcher

# Remove Bluefin bootc config
rm -f /usr/lib/bootc/install/20-bluefin.toml

# Remove ublue fastfetch and motd scripts
rm -f /usr/etc/profile.d/ublue-fastfetch.sh
rm -f /usr/etc/profile.d/ublue-motd.sh
rm -f /usr/share/fish/vendor_conf.d/ublue-fastfetch.fish
rm -f /usr/share/fish/vendor_conf.d/ublue-motd.fish
rm -f /usr/libexec/ublue-motd

# Remove Bluefin fastfetch config and logos
rm -rf /usr/share/ublue-os/bluefin-logos
rm -rf /usr/share/ublue-os/motd
rm -f /usr/etc/ublue-os/fastfetch.json
rm -f /usr/share/ublue-os/fastfetch.jsonc

# Create minimal fastfetch config (uses default Fedora logo)
mkdir -p /usr/etc/ublue-os
cat > /usr/etc/ublue-os/fastfetch.json <<'EOF'
{}
EOF

# Remove ublue/bluefin desktop shortcuts
rm -f /usr/share/applications/documentation.desktop
rm -f /usr/share/applications/discourse.desktop

# Replace system-update desktop file with clean version
rm -f /usr/share/applications/system-update.desktop
cat > /usr/share/applications/system-update.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=System Update
Comment=Update system, Flatpaks, Distrobox containers, and more
Icon=system-software-update
Categories=System;Utility;
Terminal=true
Exec=/usr/bin/ujust update
EOF

# Rebuild dconf database
if command -v dconf >/dev/null; then
    dconf update || true
fi

# Reset Plymouth (boot screen) theme to default Fedora
if command -v plymouth-set-default-theme >/dev/null; then
    plymouth-set-default-theme bgrt || plymouth-set-default-theme spinner
fi

echo "==> Bluefin/ublue branding removed, using Fedora defaults"

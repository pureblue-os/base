#!/bin/bash

set -ouex pipefail

echo "==> Removing Bluefin/ublue branding"

# Remove Bluefin backgrounds
rm -rf /usr/share/backgrounds/bluefin
rm -rf /usr/share/backgrounds/gnome
rm -rf /usr/share/backgrounds/f42
rm -rf /usr/etc/bazaar/*bluefin*.jxl

# Remove Bluefin background metadata
rm -f /usr/share/gnome-background-properties/*-bluefin.xml

# Remove Bluefin documentation
rm -rf /usr/share/doc/bluefin

# Remove Bluefin GNOME settings overrides (opinionated preferences: window buttons, fonts, keybindings, etc.)
rm -f /usr/share/glib-2.0/schemas/zz0-bluefin-modifications.gschema.override
rm -f /usr/share/glib-2.0/schemas/zz1-bluefin-modifications-mutter-exp-feats.gschema.override

# Recompile GNOME schemas after removing overrides
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Remove Bluefin Firefox config
rm -f /usr/share/ublue-os/firefox-config/01-bluefin-global.js

# Remove Bluefin Brewfiles
rm -f /usr/share/ublue-os/homebrew/bluefin-ai.Brewfile
rm -f /usr/share/ublue-os/homebrew/bluefin-cli.Brewfile
rm -f /usr/share/ublue-os/homebrew/bluefin-fonts.Brewfile
rm -f /usr/share/ublue-os/homebrew/bluefin-k8s.Brewfile

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

# Remove Bluefin user avatar faces
rm -rf /usr/share/pixmaps/faces

# Remove bluefin-logos and bluefin-plymouth packages, then install real Fedora ones
dnf5 remove -y bluefin-logos bluefin-plymouth || true
dnf5 install -y fedora-logos plymouth-theme-spinner

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
rm -f /etc/profile.d/ublue-fastfetch.sh
rm -f /etc/profile.d/ublue-motd.sh
rm -f /usr/share/fish/vendor_conf.d/ublue-fastfetch.fish
rm -f /usr/share/fish/vendor_conf.d/ublue-motd.fish
rm -f /usr/libexec/ublue-motd
rm -f /usr/libexec/ublue-fastfetch
rm -f /usr/libexec/ublue-bling-fastfetch
rm -f /usr/libexec/ublue-image-info.sh

# Remove useless ublue tools
rm -f /usr/bin/ublue-rollback-helper

# Remove Bluefin fastfetch config and logos
rm -rf /usr/share/ublue-os/bluefin-logos
rm -rf /usr/share/ublue-os/motd
rm -f /usr/etc/ublue-os/fastfetch.json
rm -f /usr/share/ublue-os/fastfetch.jsonc

# Remove ublue/bluefin desktop shortcuts
rm -f /usr/share/applications/documentation.desktop
rm -f /usr/share/applications/discourse.desktop

# Remove old system-update desktop file and create new one with different name
rm -f /usr/share/applications/system-update.desktop
cat > /usr/share/applications/update-system.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=System Update
Comment=Update system, Flatpaks, Distrobox containers, and more
Icon=software-update-available
Categories=System;Utility;
Terminal=true
Exec=/usr/bin/pureblue-update
EOF

# Rebuild dconf database
if command -v dconf >/dev/null; then
    dconf update || true
fi

# Reset Plymouth (boot screen) theme to default Fedora
if command -v plymouth-set-default-theme >/dev/null; then
    plymouth-set-default-theme bgrt || plymouth-set-default-theme spinner
fi

# Remove ublue executables
rm -f /usr/libexec/ublue-bling
rm -f /usr/libexec/ublue-changelog
rm -f /usr/libexec/ublue-image-info
rm -f /usr/libexec/ublue-rollback-helper

# Remove cosmetic/opinionated user-setup hooks (keep system-setup for Framework hardware fixes)
rm -rf /usr/share/ublue-os/user-setup.hooks.d/
rm -rf /usr/share/ublue-os/privileged-setup.hooks.d/
rm -f /usr/libexec/ublue-user-setup
rm -f /usr/libexec/ublue-privileged-setup

# Remove opinionated flatpak auto-install system (users can install flatpaks themselves)
rm -f /usr/etc/ublue-os/system-flatpaks.list
rm -f /usr/etc/ublue-os/system-flatpaks-dx.list
rm -f /usr/etc/ublue-os/system-flatpaks-extra.list
systemctl disable flatpak-preinstall.service || true

# Remove ujust and all just recipes (replaced with pureblue-update)
dnf5 remove -y ujust || true
rm -rf /usr/share/ublue-os/just
rm -f /usr/bin/ujust /usr/sbin/ujust

echo "Bluefin branding cleanup complete"

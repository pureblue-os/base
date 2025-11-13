#!/bin/bash

set -ouex pipefail

echo "==> Removing Bluefin/ublue branding"

# Remove Bluefin backgrounds
rm -rf /usr/share/backgrounds/bluefin
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

# Rebuild dconf database
if command -v dconf >/dev/null; then
    dconf update || true
fi

# Reset Plymouth (boot screen) theme to default Fedora
if command -v plymouth-set-default-theme >/dev/null; then
    plymouth-set-default-theme bgrt || plymouth-set-default-theme spinner
fi

echo "==> Bluefin/ublue branding removed, using Fedora defaults"

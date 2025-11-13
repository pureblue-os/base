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

# Remove most Bluefin branding packages (but NOT bluefin-logos yet)
dnf5 remove -y \
    bluefin-plymouth \
    bluefin-backgrounds \
    bluefin-cli-logos \
    bluefin-faces \
    bluefin-fastfetch \
    bluefin-schemas \
    || true

# Replace bluefin-logos with fedora-logos
# This works because both provide 'system-logos' which GDM requires
# --allowerasing allows replacing bluefin-logos with fedora-logos atomically
dnf5 install -y --allowerasing fedora-logos plymouth-theme-spinner

# NOW remove bluefin-logos (should already be gone from --allowerasing, but just to be sure)
dnf5 remove -y bluefin-logos || true

# Remove any lingering Bluefin-branded Plymouth/pixmap files that might not have been replaced
rm -f /usr/share/plymouth/themes/bgrt/watermark.png
rm -f /usr/share/plymouth/themes/spinner/watermark.png

# Ensure Plymouth watermark is the Fedora logo for both bgrt and spinner themes
# bgrt is the default theme used on UEFI systems
if [ -f /usr/share/pixmaps/fedora-gdm-logo.png ]; then
    mkdir -p /usr/share/plymouth/themes/bgrt
    mkdir -p /usr/share/plymouth/themes/spinner
    cp -f /usr/share/pixmaps/fedora-gdm-logo.png /usr/share/plymouth/themes/bgrt/watermark.png
    cp -f /usr/share/pixmaps/fedora-gdm-logo.png /usr/share/plymouth/themes/spinner/watermark.png
fi

# Replace os-release file with PureBlue branding
# Extract values from Fedora release files
FEDORA_VERSION=$(rpm -q --qf '%{VERSION}' fedora-release-common)
FEDORA_CODENAME=$(cat /usr/lib/fedora-release | sed 's/Fedora release [0-9]* (\(.*\))/\1/')
SUPPORT_END=$(rpm -q --qf '%{VERSION}' fedora-release-common | awk '{print 2026"-05-13"}')  # Fedora 42 support end
BUILD_DATE=$(date +%Y%m%d)

cat > /usr/lib/os-release <<EOF
NAME="PureBlue"
VERSION="${FEDORA_VERSION} (Silverblue)"
RELEASE_TYPE=stable
ID=pureblue
ID_LIKE="fedora"
VERSION_ID=${FEDORA_VERSION}
VERSION_CODENAME="${FEDORA_CODENAME}"
PLATFORM_ID="platform:f${FEDORA_VERSION}"
PRETTY_NAME="PureBlue ${FEDORA_VERSION}"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:${FEDORA_VERSION}"
DEFAULT_HOSTNAME="pureblue"
HOME_URL="https://github.com/pureblue-os"
DOCUMENTATION_URL="https://github.com/pureblue-os/base"
SUPPORT_URL="https://github.com/pureblue-os/base/issues"
BUG_REPORT_URL="https://github.com/pureblue-os/base/issues"
SUPPORT_END=${SUPPORT_END}
VARIANT="Silverblue"
VARIANT_ID=pureblue-nvidia-open
OSTREE_VERSION='${FEDORA_VERSION}.${BUILD_DATE}'
BUILD_ID="${BUILD_DATE}"
IMAGE_ID="pureblue-nvidia-open"
IMAGE_VERSION="${FEDORA_VERSION}.${BUILD_DATE}"
EOF

echo "Bluefin branding cleanup complete"

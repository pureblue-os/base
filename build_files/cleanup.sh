#!/bin/bash

set -ouex pipefail

echo "==> Removing unwanted packages from Bazzite"

# Remove gaming applications one by one to avoid failures if package doesn't exist
for pkg in steam lutris sunshine input-remapper bazzite-portal-setup rom-properties webapp-manager firefox; do
    dnf5 remove -y "$pkg" 2>/dev/null || echo "Package $pkg not found, skipping"
done

# Remove desktop shortcuts and folders
rm -rf /usr/share/applications/ublue-*.desktop || true
rm -rf /usr/share/desktop-directories/ublue-*.directory || true

echo "==> Removing Bazzite/UBlue specific configurations"

# Remove Bazzite COPR repos
rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:bazzite-org:*.repo || true
rm -f /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:ublue-os:*.repo || true
rm -f /etc/yum.repos.d/_copr_ublue-os-akmods.repo || true

# Remove Bazzite dconf settings
rm -f /etc/dconf/db/distro.d/00-bazzite-desktop-silverblue-global || true
rm -f /etc/dconf/db/distro.d/01-bazzite-desktop-silverblue-folders || true
rm -f /etc/dconf/db/distro.d/locks/00-bazzite-desktop-silverblue-global-lock || true

# Remove Bazzite profile scripts
rm -f /etc/profile.d/bazzite-neofetch.sh || true

# Remove Bazzite/UBlue directories
rm -rf /etc/bazzite || true
rm -rf /etc/ublue-os || true
rm -rf /etc/ublue || true

# Remove UBlue container signing configs (keep if you want to trust UBlue images)
# rm -f /etc/containers/registries.d/ublue-os.yaml || true
# rm -f /etc/pki/containers/ublue-os-backup.pub || true
# rm -f /etc/pki/containers/ublue-os.pub || true

# Remove Steam autostart
rm -f /etc/skel/.config/autostart/steam.desktop || true

echo "==> Resetting GNOME settings to defaults"

# Reset GNOME theme settings to defaults
# Note: These are system-wide dconf defaults, will apply to new users
mkdir -p /etc/dconf/db/local.d

cat > /etc/dconf/db/local.d/00-reset-defaults << EOF
[org/gnome/desktop/interface]
icon-theme='Adwaita'
font-name='Cantarell 11'
document-font-name='Cantarell 11'
monospace-font-name='Source Code Pro 10'
cursor-theme='Adwaita'
gtk-theme='Adwaita'
color-scheme='default'

[org/gnome/desktop/wm/preferences]
button-layout='appmenu:close'
EOF

dconf update

echo "==> Cleanup complete"

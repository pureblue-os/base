#!/bin/bash

set -ouex pipefail

echo "==> Removing unwanted GNOME extensions"

# Remove Bluefin/ublue specific extensions
rm -rf /usr/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com
rm -rf /usr/share/gnome-shell/extensions/blur-my-shell@aunetx
rm -rf /usr/share/gnome-shell/extensions/apps-menu@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/launch-new-instance@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/logomenu@aryan_k
rm -rf /usr/share/gnome-shell/extensions/places-menu@gnome-shell-extensions.gcampax.github.com
rm -rf /usr/share/gnome-shell/extensions/search-light@icedman.github.com
rm -rf /usr/share/gnome-shell/extensions/window-list@gnome-shell-extensions.gcampax.github.com

echo "==> Unwanted GNOME extensions removed"

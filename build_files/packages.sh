#!/bin/bash

set -ouex pipefail

echo "==> Installing GNOME Workstation"

# Install GNOME Workstation Environment
dnf5 install -y @workstation-product-environment

echo "==> Installing additional packages"

# Install your custom packages here
dnf5 install -y tmux

# Enable system services
systemctl enable podman.socket
systemctl enable gdm

echo "==> Packages installed"

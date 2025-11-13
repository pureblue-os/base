#!/bin/bash

set -ouex pipefail

echo "==> Installing GNOME Workstation"

# Install GNOME Workstation Environment
dnf5 install -y @workstation-product-environment

echo "==> Installing NVIDIA drivers from akmods"

# Install NVIDIA support packages and kmods from copied rpms
dnf5 install -y /tmp/rpms/ublue-os/ublue-os-nvidia*.rpm
dnf5 install -y /tmp/rpms/kmods/kmod-nvidia*.rpm

echo "==> Installing additional packages"

# Install your custom packages here
dnf5 install -y tmux

# Enable system services
systemctl enable podman.socket
systemctl enable gdm

echo "==> Packages installed"

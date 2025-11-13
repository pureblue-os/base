#!/bin/bash

set -ouex pipefail

echo "==> Installing additional packages"

# Install your custom packages here
dnf5 install -y tmux

# Enable system services
systemctl enable podman.socket

echo "==> Packages installed"

#!/bin/bash

set -ouex pipefail

echo "==> Installing ASUS laptop support"

### Install ASUS laptop support packages
dnf5 install -y \
    asusctl \
    supergfxctl

# Enable ASUS services
systemctl enable supergfxd

echo "==> ASUS support installed"

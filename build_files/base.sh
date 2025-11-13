#!/bin/bash

set -ouex pipefail

echo "==> Building base variant"

# Install base packages
bash /ctx/packages.sh

# Install ASUS laptop support (comment out if you don't have ASUS laptop)
bash /ctx/asus.sh

echo "==> Base variant build complete"

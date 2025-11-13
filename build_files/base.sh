#!/bin/bash

set -ouex pipefail

echo "==> Building base variant"

# Install base packages
/ctx/packages.sh

# Install ASUS laptop support (comment out if you don't have ASUS laptop)
/ctx/asus.sh

echo "==> Base variant build complete"

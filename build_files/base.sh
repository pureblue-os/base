#!/bin/bash

set -ouex pipefail

echo "==> Building base variant"

# Remove Bluefin branding
bash /ctx/branding.sh

# Install base packages
bash /ctx/packages.sh

echo "==> Base variant build complete"

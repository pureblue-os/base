#!/bin/bash

set -ouex pipefail

echo "==> Building base variant"

# Install base packages
bash /ctx/packages.sh

echo "==> Base variant build complete"

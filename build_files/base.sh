#!/bin/bash

set -ouex pipefail

echo "==> Building base variant"

bash /ctx/cleanup-branding.sh
bash /ctx/cleanup.sh
bash /ctx/extensions.sh
bash /ctx/packages.sh

echo "==> Base variant build complete"

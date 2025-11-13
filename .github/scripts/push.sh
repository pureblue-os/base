#!/bin/bash
set -euo pipefail

# Push images and collect digests for signing
# Usage: ./push.sh "$IMAGES"

IMAGES="$1"
DIGESTS=""

for image in $IMAGES; do
    echo "Pushing ${image}..."
    podman push ${image} --digestfile=/tmp/digest.txt
    digest=$(cat /tmp/digest.txt)
    registry_path=$(echo ${image} | cut -d: -f1)
    echo "Digest: ${registry_path}@${digest}"
    DIGESTS="${DIGESTS} ${registry_path}@${digest}"
done

# Output for GitHub Actions
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "digests=${DIGESTS}" >> $GITHUB_OUTPUT
else
    echo "${DIGESTS}"
fi

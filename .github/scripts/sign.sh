#!/bin/bash
set -euo pipefail

# Sign images by digest
# Usage: ./sign.sh "$DIGESTS"

DIGESTS="$1"

for digest in $DIGESTS; do
    echo "Signing ${digest}..."
    cosign sign -y --key env://COSIGN_PRIVATE_KEY ${digest}
done

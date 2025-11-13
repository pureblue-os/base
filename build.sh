#!/bin/bash
set -euo pipefail

# Build script for PureBlue OS base images
# Can be used locally or in CI

# Detect Fedora version from latest bootc image
FEDORA_VERSION=${FEDORA_VERSION:-$(podman run --rm quay.io/fedora/fedora-bootc:latest grep -oP '(?<=VERSION_ID=)\d+' /usr/lib/os-release)}
echo "Building for Fedora version: ${FEDORA_VERSION}"

# Image registry (default to empty for local dev, include trailing slash for remote)
REGISTRY=${REGISTRY:-"localhost/pureblue-os"}

# Generate date tag
DATE_TAG=$(date +%Y%m%d)

# Tag suffixes to apply to each variant
TAG_SUFFIXES="latest ${FEDORA_VERSION} ${FEDORA_VERSION}.${DATE_TAG}"

# Build all variants or specific one
VARIANTS=${1:-"base base-nvidia base-nvidia-open gnome gnome-nvidia gnome-nvidia-open"}

# Track all built images
BUILT_IMAGES=""

for variant in $VARIANTS; do
    echo ""
    echo "========================================"
    echo "Building ${variant} variant..."
    echo "========================================"
    
    # Build tags for this variant
    TAGS=""
    for suffix in $TAG_SUFFIXES; do
        TAGS="${TAGS} --tag ${REGISTRY}/${variant}:${suffix}"
    done
    
    podman build \
        --file "Containerfile.${variant}" \
        ${TAGS} \
        --build-arg "FEDORA_VERSION=${FEDORA_VERSION}" \
        --build-arg "REGISTRY=${REGISTRY}" \
        .
    
    # Append built images to list
    for suffix in $TAG_SUFFIXES; do
        BUILT_IMAGES="${BUILT_IMAGES} ${REGISTRY}/${variant}:${suffix}"
    done
    
    echo "✓ Built ${REGISTRY}/${variant} with tags: ${TAG_SUFFIXES}"
done

echo ""
echo "========================================"
echo "Build complete!"
echo "========================================"
echo "Built images:"
for image in $BUILT_IMAGES; do
    echo "  - ${image}"
done

# Output for CI workflows to capture
if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "images=${BUILT_IMAGES}" >> $GITHUB_OUTPUT
fi

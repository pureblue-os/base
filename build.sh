#!/bin/bash
set -euo pipefail

# Build script for Pureblue OS base images
# Can be used locally or in CI

BASE_IMAGE="quay.io/fedora/fedora-bootc"

# Detect Fedora version from latest bootc image
FEDORA_VERSION=${FEDORA_VERSION:-$(podman run --rm ${BASE_IMAGE}:latest grep -oP '(?<=VERSION_ID=)\d+' /usr/lib/os-release)}
echo "Building for Fedora version: ${FEDORA_VERSION}"

# Get the base image digest (short SHA - first 8 chars)
BASE_IMAGE_DIGEST=$(skopeo inspect --format '{{.Digest}}' docker://${BASE_IMAGE}:${FEDORA_VERSION} | cut -d: -f2 | head -c 8)
echo "Base image digest: ${BASE_IMAGE_DIGEST}"

# Get current commit SHA (short - first 8 chars)
if [ -d .git ]; then
    COMMIT_SHA=$(git rev-parse --short=8 HEAD)
else
    COMMIT_SHA=${GITHUB_SHA:+${GITHUB_SHA:0:8}}
    COMMIT_SHA=${COMMIT_SHA:-"local"}
fi
echo "Commit SHA: ${COMMIT_SHA}"

# Image registry (default to localhost for local dev)
REGISTRY=${REGISTRY:-"localhost/pureblue-os"}

# Build the unique tag: {fedora_version}.{base_image_sha}.{commit_sha}
UNIQUE_TAG="${FEDORA_VERSION}.${BASE_IMAGE_DIGEST}.${COMMIT_SHA}"
PARTIAL_TAG="${FEDORA_VERSION}.${BASE_IMAGE_DIGEST}"

# Tag suffixes to apply to each variant
TAG_SUFFIXES="latest ${FEDORA_VERSION} ${PARTIAL_TAG} ${UNIQUE_TAG}"

echo "Tags to be applied: ${TAG_SUFFIXES}"

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
    echo "unique_tag=${UNIQUE_TAG}" >> $GITHUB_OUTPUT
    echo "fedora_version=${FEDORA_VERSION}" >> $GITHUB_OUTPUT
    echo "base_image_digest=${BASE_IMAGE_DIGEST}" >> $GITHUB_OUTPUT
fi

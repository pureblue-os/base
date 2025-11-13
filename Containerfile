# PureBlue OS - Built from Fedora bootc base
# A clean, minimal GNOME desktop with NVIDIA drivers

# Accept Fedora version as build arg (workflow can pass this, defaults to 42)
ARG FEDORA_VERSION=42
ARG VARIANT=base

# Stage 0: Build context for scripts
FROM scratch AS ctx
COPY build_files /

# Stage 1: Fedora bootc base
FROM quay.io/fedora/fedora-bootc:${FEDORA_VERSION} AS fedora-base

# Stage 2: Get akmods RPMs (NVIDIA drivers + kernel modules)
FROM ghcr.io/ublue-os/akmods-nvidia-open:main-${FEDORA_VERSION} AS akmods-nvidia

# Stage 3: Get common akmods
FROM ghcr.io/ublue-os/akmods:main-${FEDORA_VERSION} AS akmods-common

# Stage 4: Main build
FROM fedora-base

# Make /opt mutable for packages like Chrome, Docker Desktop
RUN test -L /opt || { rmdir /opt && ln -s /var/opt /opt; } && \
    mkdir -p /var/roothome /var/opt

# Copy entire akmods filesystem (contains RPMs at /tmp/rpms)
COPY --from=akmods-nvidia / /tmp/akmods-nvidia
COPY --from=akmods-common / /tmp/akmods-common

# Debug: Check what RPMs we have and what's in nvidia-vars
RUN find /tmp/akmods-nvidia -name "*.rpm" && \
    find /tmp/akmods-common -name "*nvidia*" && \
    if [ -f /tmp/akmods-nvidia/rpms/kmods/nvidia-vars ]; then cat /tmp/akmods-nvidia/rpms/kmods/nvidia-vars; fi

# Install matching kernel from akmods (required for kmod compatibility)
RUN dnf5 install -y \
    /tmp/akmods-nvidia/kernel-rpms/kernel-[0-9]*.rpm \
    /tmp/akmods-nvidia/kernel-rpms/kernel-core-*.rpm \
    /tmp/akmods-nvidia/kernel-rpms/kernel-modules-*.rpm \
    /tmp/akmods-nvidia/kernel-rpms/kernel-modules-core-*.rpm \
    /tmp/akmods-nvidia/kernel-rpms/kernel-modules-extra-*.rpm

# Install NVIDIA support packages (this creates nvidia repos)
RUN dnf5 install -y \
    /tmp/akmods-nvidia/rpms/ublue-os/ublue-os-nvidia-addons-*.rpm \
    /tmp/akmods-common/rpms/ublue-os/ublue-os-akmods-addons-*.rpm || true

# Check what repos were created and enable them
RUN ls -la /etc/yum.repos.d/ && \
    find /etc/yum.repos.d/ -name "*nvidia*" -exec sed -i 's/enabled=0/enabled=1/g' {} \; || true

# Install NVIDIA drivers from repos (this provides nvidia-kmod-common)
RUN dnf5 install -y \
    nvidia-driver \
    nvidia-driver-cuda \
    nvidia-settings || \
    echo "NVIDIA packages not found in repos, will install kmod directly"

# Now install the kernel module (nvidia-kmod-common should be satisfied)
RUN dnf5 install -y \
    /tmp/akmods-nvidia/rpms/kmods/kmod-nvidia-*.rpm \
    && rm -rf /tmp/akmods-nvidia /tmp/akmods-common

# Install GNOME Desktop Environment
RUN dnf5 install -y \
    @workstation-product-environment \
    && dnf5 clean all

# Enable GDM (GNOME Display Manager) for graphical login
RUN systemctl enable gdm.service

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    bash /ctx/${VARIANT}.sh
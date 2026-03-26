# Pureblue OS Base Images

This directory contains the base images for Pureblue OS, built on top of Fedora
bootc.

## Image Hierarchy

```
fedora-bootc:latest
    │
    ├── base ────┬── gnome
    │            │
    │            ├── base-nvidia ─── gnome-nvidia        [RPM Fusion - proprietary]
    │            │
    │            └── base-nvidia-open ─── gnome-nvidia-open  [negativo17 - open modules]
```

## Available Images

### Base Images

| Image              | From           | Description                             |
| ------------------ | -------------- | --------------------------------------- |
| `base`             | `fedora-bootc` | Minimal base with core packages         |
| `base-nvidia`      | `base`         | NVIDIA proprietary drivers (RPM Fusion) |
| `base-nvidia-open` | `base`         | NVIDIA open kernel modules (negativo17) |

### Desktop Images

| Image               | From               | Description                        |
| ------------------- | ------------------ | ---------------------------------- |
| `gnome`             | `base`             | GNOME Desktop Environment          |
| `gnome-nvidia`      | `base-nvidia`      | GNOME + proprietary NVIDIA drivers |
| `gnome-nvidia-open` | `base-nvidia-open` | GNOME + open NVIDIA modules        |

## NVIDIA Variants Explained

### `base-nvidia` (Proprietary)

- **Source**: RPM Fusion repos
- **Driver type**: Proprietary (closed source) kernel modules
- **Stability**: More tested, conservative updates
- **Hardware support**: All NVIDIA GPUs (legacy to latest)
- **Use when**: You want maximum stability or have older hardware

### `base-nvidia-open` (Open Source)

- **Source**: negativo17 repos
- **Driver type**: Open source kernel modules (userspace still proprietary)
- **Stability**: Newer, faster updates
- **Hardware support**: RTX 20 series and newer
- **Use when**: You want newer drivers or better Wayland support

## Build Process

The images are built weekly (Sundays at 10:05 UTC) via GitHub Actions.

### Build Pipeline

```
check
└── build-base ───┬── build-gnome
                  ├── build-nvidia ─── build-gnome-nvidia
                  └── build-nvidia-open ─── build-gnome-nvidia-open
```

Builds happen in parallel where possible:

- `build-gnome` runs parallel with `build-nvidia` and `build-nvidia-open`
- Desktop variants wait for their respective base images

## Versioning

Images are tagged with:

- `latest` - Always the most recent build
- `{fedora_version}` - e.g., `43`
- `{fedora_version}.commit-{sha}` - e.g., `43.commit-a1b2c3d4` (shared across variants from same commit)
- `{fedora_version}.base-{digest}` - e.g., `43.base-e5f6789a` (same base digest)
- `{fedora_version}.commit-{sha}.base-{digest}` - e.g., `43.commit-a1b2c3d4.base-e5f6789a` (full traceability)

## Containerfiles

- `Containerfile.base` - Minimal base image
- `Containerfile.base-nvidia` - NVIDIA proprietary (RPM Fusion)
- `Containerfile.base-nvidia-open` - NVIDIA open modules (negativo17)
- `Containerfile.gnome` - GNOME desktop
- `Containerfile.gnome-nvidia` - GNOME + proprietary NVIDIA
- `Containerfile.gnome-nvidia-open` - GNOME + open NVIDIA modules

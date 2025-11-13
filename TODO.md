# PureBlue TODO

## Future Cleanup Items

### ujust

- Currently using ublue's ujust for system updates
- Plan: Create minimal PureBlue version with just essential commands
- Only need: update functionality, basic system management
- Can remove: bluefin-specific commands, unnecessary bling

### Homebrew

- Currently using ublue's homebrew setup from `/usr/share/ublue-os/homebrew/`
- Plan: Re-add homebrew ourselves in the image
- Easy to install, gives us full control over the setup

### Flatpak Overrides

- `/usr/share/ublue-os/flatpak-overrides/` currently has Bazaar override
- Plan: Override target needs to change later when we fork Bazaar

### Bazaar

- Fork bluefin's Bazaar to create purebazaar, make it pure.

### udev-rules

- `/usr/share/ublue-os/udev-rules/` contains useful hardware compatibility rules
- Keep for now: Framework, Steam controllers, USB devices, etc.
- Evaluate later if we want to maintain our own set

### image-info.json

- `/usr/share/ublue-os/image-info.json` still references bluefin
- Update with PureBlue image information

### Rename ublue-os directory

- Eventually rename `/usr/share/ublue-os/` to `/usr/share/pureblue-os/`
- Requires updating all references in:
  - `/usr/libexec/ublue-*` scripts
  - systemd services
  - config files
  - any other dependencies
- Tackle once we have our own infrastructure and understand all dependencies

## Long-term Goals

### Build our own base image

- Currently using Bluefin as base (mainly for nvidia support)
- Long-term: Create PureBlue base from scratch (Fedora Silverblue/Kinoite +
  nvidia)
- Need to understand:
  - How ublue handles nvidia drivers and akmods
  - Image building and signing process
  - Ostree layering and updates
- This will give us full control without inheriting ublue infrastructure

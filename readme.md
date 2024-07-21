# Server

> **Do not use this image! This is built only for my own use, I don't recommend anyone using artifacts from this repo directly, rather use it as a base to fork and create your own.**

A minimal base image for Fedora Silverblue. This strips out most unnecessary packages (Firefox, desktop backgrounds, etc) while leaving a useable but very minimal desktop base which can be built upon.

# Installation

Rebase from an existing tag.

```
sudo rpm-ostree rebase --bypass-driver --reboot ostree-unverified-registry:ghcr.io/ngarside/server:latest
```

# Upgrading

Manually upgrade to a new tag.

```
rpm-ostree upgrade
```

# Uninstall All Flatpaks & Data

This will delete all user data stored by Flatpaks!

```
flatpak remove --all --delete-data --noninteractive
```

# License

This is free and unencumbered software released into the public domain.

# Other

```shell
docker run --interactive --rm quay.io/coreos/butane:release --pretty --strict < butane.yml > ignition.json

# not needed, just to wipe drive
sudo wipefs --all /dev/sda

sudo coreos-installer install /dev/sda --ignition-url https://serverst.blob.core.windows.net/butane-public/ignition.json

# remove drive

sudo reboot
```

#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Creates a new virtual machine.

set -euo pipefail

# Create root disk image -------------------------------------------------------

qemu-img create -f qcow2 /var/lib/libvirt/images/server-root.qcow2 64G

# Create data disk image -------------------------------------------------------

qemu-img create -f qcow2 /var/lib/libvirt/images/server-data.qcow2 512G

modprobe nbd max_part=8

qemu-nbd --connect /dev/nbd0 /var/lib/libvirt/images/server-data.qcow2

parted /dev/nbd0 mklabel gpt

parted --align optimal /dev/nbd0 mkpart primary 0% 100%

mkfs.btrfs --force --label data /dev/nbd0p1

qemu-nbd --disconnect /dev/nbd0

# Create virtual machine -------------------------------------------------------

CONFIG="$(dirname "${BASH_SOURCE[0]}")/config.xml"

virsh --connect qemu:///system define "$CONFIG"

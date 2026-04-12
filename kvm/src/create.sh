#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Creates a new virtual machine.

set -euo pipefail

# Create root disk image -------------------------------------------------------

qemu-img create --format qcow2 /var/lib/libvirt/images/server-sda.qcow2 240000000000

# Create data disk images ------------------------------------------------------

qemu-img create --format qcow2 /var/lib/libvirt/images/server-nvme0n1.qcow2 2000000000000
qemu-img create --format qcow2 /var/lib/libvirt/images/server-nvme1n1.qcow2 2000000000000
qemu-img create --format qcow2 /var/lib/libvirt/images/server-nvme2n1.qcow2 2000000000000

modprobe nbd max_part=8

qemu-nbd --connect /dev/nbd0 /var/lib/libvirt/images/server-nvme0n1.qcow2
qemu-nbd --connect /dev/nbd1 /var/lib/libvirt/images/server-nvme1n1.qcow2
qemu-nbd --connect /dev/nbd2 /var/lib/libvirt/images/server-nvme2n1.qcow2

parted /dev/nbd0 mklabel gpt
parted /dev/nbd1 mklabel gpt
parted /dev/nbd2 mklabel gpt

parted --align optimal /dev/nbd0 mkpart primary 0% 100%
parted --align optimal /dev/nbd1 mkpart primary 0% 100%
parted --align optimal /dev/nbd2 mkpart primary 0% 100%

mkfs.btrfs --force --label data /dev/nbd0p1 /dev/nbd1p1 /dev/nbd2p1

qemu-nbd --disconnect /dev/nbd0
qemu-nbd --disconnect /dev/nbd1
qemu-nbd --disconnect /dev/nbd2

# Create virtual machine -------------------------------------------------------

CONFIG="$(dirname "${BASH_SOURCE[0]}")/config.xml"

virsh --connect qemu:///system define "$CONFIG"

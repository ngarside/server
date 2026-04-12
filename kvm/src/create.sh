#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Creates a new virtual machine.

set -euo pipefail

ROOT="/var/lib/libvirt/images"

# Create root disk image -------------------------------------------------------

qemu-img create --format qcow2 "$ROOT/server-sda.qcow2" 240000000000

# Create data disk images ------------------------------------------------------

qemu-img create --format qcow2 "$ROOT/server-nvme0n1.qcow2" 2000000000000
qemu-img create --format qcow2 "$ROOT/server-nvme1n1.qcow2" 2000000000000
qemu-img create --format qcow2 "$ROOT/server-nvme2n1.qcow2" 2000000000000

modprobe nbd max_part=8

qemu-nbd --connect /dev/nbd0 "$ROOT/server-nvme0n1.qcow2"
qemu-nbd --connect /dev/nbd1 "$ROOT/server-nvme1n1.qcow2"
qemu-nbd --connect /dev/nbd2 "$ROOT/server-nvme2n1.qcow2"

parted /dev/nbd0 mklabel gpt
parted /dev/nbd1 mklabel gpt
parted /dev/nbd2 mklabel gpt

mkfs.btrfs --force --label data /dev/nbd0 /dev/nbd1 /dev/nbd2

qemu-nbd --disconnect /dev/nbd0
qemu-nbd --disconnect /dev/nbd1
qemu-nbd --disconnect /dev/nbd2

# Create virtual machine -------------------------------------------------------

CONFIG="$(dirname "${BASH_SOURCE[0]}")/config.xml"

virsh --connect qemu:///system define "$CONFIG"

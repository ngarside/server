#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Creates a new virtual machine.

set -euo pipefail

# Ensure running as root -------------------------------------------------------

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

# Create root disk image -------------------------------------------------------

qemu-img create -f qcow2 /var/lib/libvirt/images/server-root.qcow2 64G

# Create data disk image -------------------------------------------------------

qemu-img create -f qcow2 /var/lib/libvirt/images/server-data.qcow2 512G
mkfs.btrfs /var/lib/libvirt/images/server-data.qcow2

# Create virtual machine -------------------------------------------------------

XML="$(dirname $BASH_SOURCE[0])/config.xml"
virsh define "$XML"

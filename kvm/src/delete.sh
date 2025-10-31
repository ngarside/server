#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Deletes an existing virtual machine.

set -euo pipefail

# Delete the virtual machine ---------------------------------------------------

virsh --connect qemu:///system destroy Server || true
virsh --connect qemu:///system undefine Server

# Delete the disk images -------------------------------------------------------

rm /var/lib/libvirt/images/server-root.qcow2
rm /var/lib/libvirt/images/server-data.qcow2

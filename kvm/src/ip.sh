#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Prints the IP address of the virtual machine.

set -euo pipefail

IP=$(virsh --connect qemu:///system net-dhcp-leases default | grep --only-matching "192[^/]*")

echo "$IP"

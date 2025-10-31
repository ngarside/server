#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Prints the IP address of the virtual machine.

set -euo pipefail

# Ensure running as root -------------------------------------------------------

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

# Find & print the virtual machine's IP ----------------------------------------

IP=$(virsh --connect qemu:///system net-dhcp-leases default | grep --only-matching "192[^/]*")

echo $IP

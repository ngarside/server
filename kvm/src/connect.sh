#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Connects to the virtual machine via SSH.

set -euo pipefail

# Ensure running as root -------------------------------------------------------

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

# Connect to the virtual machine -----------------------------------------------

IP=$(virsh net-dhcp-leases default | grep --only-matching 192[^/]*)

sudo -u "$SUDO_USER" ssh \
	-o StrictHostKeyChecking=no \
	-o UserKnownHostsFile=/dev/null \
	core@$IP 2> /dev/null

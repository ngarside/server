#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Boots the virtual machine if it's currently powered off.

set -euo pipefail

# Ensure running as root -------------------------------------------------------

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

# Start the virtual machine ----------------------------------------------------

virsh --connect qemu:///system start Server

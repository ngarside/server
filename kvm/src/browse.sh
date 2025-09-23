#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Opens the virtual machine's homepage in the default browser.

set -euo pipefail

# Ensure running as root -------------------------------------------------------

if [[ "$USER" != "root" ]]; then
	echo "Script must be run as superuser; exiting"
	exit 1
fi

# Open the virtual machine's homepage ------------------------------------------

IP=$(virsh net-dhcp-leases default | grep --only-matching 192[^/]*)

xdg-open "http://$IP"

#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Opens the virtual machine's homepage in the default browser.

set -euo pipefail

IP=$(virsh --connect qemu:///system net-dhcp-leases default | grep --only-matching "192[^/]*")

xdg-open "http://$IP"

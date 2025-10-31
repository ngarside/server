#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Connects to the virtual machine via SSH.

set -euo pipefail

IP=$(virsh --connect qemu:///system net-dhcp-leases default | grep --only-matching "192[^/]*")

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$IP" 2> /dev/null

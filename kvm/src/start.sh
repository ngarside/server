#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Boots the virtual machine if it's currently powered off.

set -euo pipefail

virsh --connect qemu:///system start Server

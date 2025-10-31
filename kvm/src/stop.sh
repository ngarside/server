#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.
# Shuts down the virtual machine if it's currently running.

set -euo pipefail

virsh --connect qemu:///system shutdown Server

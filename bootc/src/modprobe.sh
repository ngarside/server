#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

echo 'install sctp /bin/true' > /etc/modprobe.d/sctp.conf
echo 'install tipc /bin/true' > /etc/modprobe.d/tipc.conf

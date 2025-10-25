#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

echo 'install firewire-core /bin/true' > /etc/modprobe.d/firewire-core.conf
echo 'install firewire-net /bin/true' > /etc/modprobe.d/firewire-net.conf
echo 'install firewire-ohci /bin/true' > /etc/modprobe.d/firewire-ohci.conf
echo 'install firewire-sbp2 /bin/true' > /etc/modprobe.d/firewire-sbp2.conf
echo 'install sctp /bin/true' > /etc/modprobe.d/sctp.conf
echo 'install tipc /bin/true' > /etc/modprobe.d/tipc.conf

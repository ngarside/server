#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/sysctl.d

cp /tmp/git/ostree/ops/vconsole.conf /usr/etc/vconsole.conf

cp /tmp/git/ostree/ops/sysctl.conf /usr/etc/sysctl.d/0-server.conf

cp /tmp/git/ostree/ops/subuid.txt /usr/etc/subuid

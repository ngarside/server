#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/sysctl.d

cp /tmp/git/ostree/ops/vconsole.conf /etc/vconsole.conf

cp /tmp/git/ostree/ops/sysctl.conf /etc/sysctl.d/0-server.conf

cp /tmp/git/ostree/ops/subuid.txt /etc/subuid

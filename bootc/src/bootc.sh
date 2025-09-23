#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/sysctl.d

cp /tmp/git/bootc/ops/vconsole.conf /etc/vconsole.conf

cp /tmp/git/bootc/ops/sysctl.conf /etc/sysctl.d/0-server.conf

cp /tmp/git/bootc/ops/subuid.txt /etc/subuid

mkdir --parents /etc/sudoers.d
cp /tmp/git/bootc/ops/sudoers.conf /etc/sudoers.d/server
chmod 0440 /etc/sudoers.d/server

cp /tmp/git/bootc/ops/root.conf /usr/lib/ostree/prepare-root.conf
KERNEL=$(cd /usr/lib/modules && echo *)
dracut --force --verbose /usr/lib/modules/$KERNEL/initramfs.img $KERNEL

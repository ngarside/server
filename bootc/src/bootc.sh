#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/sysctl.d

cp /git/bootc/ops/kernel/vconsole.conf /etc/vconsole.conf

cp /git/bootc/ops/kernel/sysctl.conf /etc/sysctl.d/0-server.conf

cp /git/bootc/ops/users/subuid.txt /etc/subuid

cp /git/bootc/ops/fstab/fstab.conf /etc/fstab

mkdir --parents /etc/sudoers.d
cp /git/bootc/ops/sudo/sudoers.conf /etc/sudoers.d/server
chmod 0440 /etc/sudoers.d/server

cp /git/bootc/ops/ostree/root.conf /usr/lib/ostree/prepare-root.conf
KERNEL=$(cd /usr/lib/modules && echo *)
dracut --force --verbose "/usr/lib/modules/$KERNEL/initramfs.img" "$KERNEL"

cp /git/bootc/ops/fstab/data.service /usr/lib/systemd/system/data-chown.service

systemctl enable data-chown.service

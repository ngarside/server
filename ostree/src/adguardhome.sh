#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/containers/systemd/users/1001
mkdir --parents /usr/etc/systemd/resolved.conf.d

cp /tmp/git/adguardhome/ops/adguardhome.container /usr/etc/containers/systemd/users/1001/adguardhome.container
cp /tmp/git/adguardhome/ops/adguardhome.network /usr/etc/containers/systemd/users/1001/adguardhome.network
cp /tmp/git/adguardhome/ops/stub.conf /usr/etc/systemd/resolved.conf.d/stub.conf

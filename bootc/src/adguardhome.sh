#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
mkdir --parents /etc/systemd/resolved.conf.d

cp /tmp/git/adguardhome/ops/adguardhome.container /etc/containers/systemd/users/1001/adguardhome.container
cp /tmp/git/adguardhome/ops/adguardhome.network /etc/containers/systemd/users/1001/adguardhome.network
cp /tmp/git/adguardhome/ops/stub.conf /etc/systemd/resolved.conf.d/stub.conf

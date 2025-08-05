#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /usr/etc/ssh/authorized_keys
mkdir --parents /usr/etc/ssh/sshd_config.d

cp /tmp/git/sshd/ops/authorizedkeys.conf /usr/etc/ssh/sshd_config.d/20-authorizedkeys.conf
cp /tmp/git/sshd/ops/hardening.conf /usr/etc/ssh/sshd_config.d/10-hardening.conf
cp /tmp/git/sshd/ops/authorizedkeys.pub /usr/etc/ssh/authorized_keys/core

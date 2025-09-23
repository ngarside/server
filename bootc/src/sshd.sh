#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/ssh/authorized_keys
mkdir --parents /etc/ssh/sshd_config.d

cp /git/sshd/ops/authorizedkeys.conf /etc/ssh/sshd_config.d/20-authorizedkeys.conf
cp /git/sshd/ops/hardening.conf /etc/ssh/sshd_config.d/10-hardening.conf
cp /git/sshd/ops/authorizedkeys.pub /etc/ssh/authorized_keys/core

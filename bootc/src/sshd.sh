#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/ssh/authorized_keys
mkdir --parents /etc/ssh/sshd_config.d

cp /git/bootc/ops/sshd/keygen.sh /usr/bin/keygen
cp /git/bootc/ops/sshd/keygen.service /usr/lib/systemd/system/keygen.service
cp /git/bootc/ops/sshd/authorizedkeys.conf /etc/ssh/sshd_config.d/20-authorizedkeys.conf
cp /git/bootc/ops/sshd/hardening.conf /etc/ssh/sshd_config.d/10-hardening.conf
cp /git/bootc/ops/sshd/authorizedkeys.pub /etc/ssh/authorized_keys/nathan

ln --symbolic /var/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
ln --symbolic /var/ssh/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
ln --symbolic /var/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key
ln --symbolic /var/ssh/ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub
ln --symbolic /var/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_rsa_key
ln --symbolic /var/ssh/ssh_host_rsa_key.pub /etc/ssh/ssh_host_rsa_key.pub

chmod u=rwx,go=rx /usr/bin/keygen

systemctl enable keygen.service

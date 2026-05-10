#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

ROOT="${1:-$(pwd)}"

mkdir --parents "$ROOT"

if [ ! -f "$ROOT/ssh_host_ecdsa_key" ]; then
	ssh-keygen -C '' -f "$ROOT/ssh_host_ecdsa_key" -P '' -t ecdsa
fi

if [ ! -f "$ROOT/ssh_host_ed25519_key" ]; then
	ssh-keygen -C '' -f "$ROOT/ssh_host_ed25519_key" -P '' -t ed25519
fi

if [ ! -f "$ROOT/ssh_host_rsa_key" ]; then
	ssh-keygen -b 4096 -C '' -f "$ROOT/ssh_host_rsa_key" -P '' -t rsa
fi

chcon --type sshd_key_t "$ROOT/*"

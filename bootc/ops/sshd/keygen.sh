#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents ./var/ssh

if [ ! -f /var/ssh/ssh_host_ecdsa_key ]; then
	ssh-keygen -C '' -f /var/ssh/ssh_host_ecdsa_key -P '' -t ecdsa
fi

if [ ! -f /var/ssh/ssh_host_ed25519_key ]; then
	ssh-keygen -C '' -f /var/ssh/ssh_host_ed25519_key -P '' -t ed25519
fi

if [ ! -f /var/ssh/ssh_host_rsa_key ]; then
	ssh-keygen -b 4096 -C '' -f /var/ssh/ssh_host_rsa_key -P '' -t rsa
fi

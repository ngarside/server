#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

ROOT="${1:-$(pwd)}"

mkdir --parents "$ROOT"

# Generate ECDSA key if it doesn't already exist -------------------------------
if [ -f "$ROOT/ssh_host_ecdsa_key" ]; then
	echo "[SSHD Keygen] ECDSA key already exists - skipping"
else
	echo "[SSHD Keygen] ECDSA key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ecdsa_key" -P '' -t ecdsa
	echo "[SSHD Keygen] ECDSA key generated"
fi

# Generate ED25519 key if it doesn't already exist -----------------------------
if [ -f "$ROOT/ssh_host_ed25519_key" ]; then
	echo "[SSHD Keygen] ED25519 key already exists - skipping"
else
	echo "[SSHD Keygen] ED25519 key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ed25519_key" -P '' -t ed25519
	echo "[SSHD Keygen] ED25519 key generated"
fi

# Generate RSA key if it doesn't already exist ---------------------------------
if [ -f "$ROOT/ssh_host_rsa_key" ]; then
	echo "[SSHD Keygen] RSA key already exists - skipping"
else
	echo "[SSHD Keygen] RSA key not found - generating"
	ssh-keygen -b 4096 -C '' -f "$ROOT/ssh_host_rsa_key" -P '' -t rsa
	echo "[SSHD Keygen] RSA key generated"
fi

# Ensure all generated keys are labelled correctly -----------------------------
chcon --type sshd_key_t "$ROOT/*"

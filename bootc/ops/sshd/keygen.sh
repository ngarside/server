#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

# Find the root directory ------------------------------------------------------
echo "[SSHD Keygen] Finding root directory"
if [ -n "${1}" ]; then
	ROOT="${1}"
	echo "[SSHD Keygen] Using alternative root directory [$ROOT]"
else
	ROOT = "$(pwd)"
	echo "[SSHD Keygen] Using current root directory [$ROOT]"
fi

# Create the root directory ----------------------------------------------------
echo "[SSHD Keygen] Creating root directory [$ROOT]"
mkdir --parents "$ROOT"
echo "[SSHD Keygen] Root directory created"

# Generate ECDSA key if it doesn't already exist -------------------------------
echo "[SSHD Keygen] Checking for existing ECDSA key"
if [ -f "$ROOT/ssh_host_ecdsa_key" ]; then
	echo "[SSHD Keygen] ECDSA key already exists - skipping"
else
	echo "[SSHD Keygen] ECDSA key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ecdsa_key" -P '' -t ecdsa
	echo "[SSHD Keygen] ECDSA key generated"
fi

# Generate ED25519 key if it doesn't already exist -----------------------------
echo "[SSHD Keygen] Checking for existing ED25519 key"
if [ -f "$ROOT/ssh_host_ed25519_key" ]; then
	echo "[SSHD Keygen] ED25519 key already exists - skipping"
else
	echo "[SSHD Keygen] ED25519 key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ed25519_key" -P '' -t ed25519
	echo "[SSHD Keygen] ED25519 key generated"
fi

# Generate RSA key if it doesn't already exist ---------------------------------
echo "[SSHD Keygen] Checking for existing RSA key"
if [ -f "$ROOT/ssh_host_rsa_key" ]; then
	echo "[SSHD Keygen] RSA key already exists - skipping"
else
	echo "[SSHD Keygen] RSA key not found - generating"
	ssh-keygen -b 4096 -C '' -f "$ROOT/ssh_host_rsa_key" -P '' -t rsa
	echo "[SSHD Keygen] RSA key generated"
fi

# Ensure all generated keys are labelled correctly -----------------------------
chcon --type sshd_key_t "$ROOT/*"

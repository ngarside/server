#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# Initial setup ----------------------------------------------------------------
set -euo pipefail
echo "[SSHD Keygen] Script initialising"

# Find the root directory ------------------------------------------------------
echo "[SSHD Keygen] Checking for provided root path"
if [ -n "${1}" ]; then
	ROOT="$(realpath "${1}")"
	echo "[SSHD Keygen]   Root path provided - using [$ROOT]"
else
	ROOT="$(pwd)"
	echo "[SSHD Keygen]   Root path not provided - using [$ROOT]"
fi

# Create the root directory ----------------------------------------------------
echo "[SSHD Keygen] Checking for existing root directory"
if [ -d "$ROOT" ]; then
	echo "[SSHD Keygen]   Root directory already exists - skipping"
else
	echo "[SSHD Keygen]   Root directory not found - creating"
	mkdir --parents "$ROOT"
	echo "[SSHD Keygen]   Root directory created"
fi

# Generate ECDSA key if it doesn't already exist -------------------------------
echo "[SSHD Keygen] Checking for existing ECDSA key"
if [ -f "$ROOT/ssh_host_ecdsa_key" ]; then
	echo "[SSHD Keygen]   ECDSA key already exists - skipping"
else
	echo "[SSHD Keygen]   ECDSA key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ecdsa_key" -P '' -t ecdsa > /dev/null
	chcon --type sshd_key_t "$ROOT/ssh_host_ecdsa_key"
	echo "[SSHD Keygen]   ECDSA key generated"
fi

# Generate ED25519 key if it doesn't already exist -----------------------------
echo "[SSHD Keygen] Checking for existing ED25519 key"
if [ -f "$ROOT/ssh_host_ed25519_key" ]; then
	echo "[SSHD Keygen]   ED25519 key already exists - skipping"
else
	echo "[SSHD Keygen]   ED25519 key not found - generating"
	ssh-keygen -C '' -f "$ROOT/ssh_host_ed25519_key" -P '' -t ed25519 > /dev/null
	chcon --type sshd_key_t "$ROOT/ssh_host_ed25519_key"
	echo "[SSHD Keygen]   ED25519 key generated"
fi

# Generate RSA key if it doesn't already exist ---------------------------------
echo "[SSHD Keygen] Checking for existing RSA key"
if [ -f "$ROOT/ssh_host_rsa_key" ]; then
	echo "[SSHD Keygen]   RSA key already exists - skipping"
else
	echo "[SSHD Keygen]   RSA key not found - generating"
	ssh-keygen -b 4096 -C '' -f "$ROOT/ssh_host_rsa_key" -P '' -t rsa > /dev/null
	chcon --type sshd_key_t "$ROOT/ssh_host_rsa_key"
	echo "[SSHD Keygen]   RSA key generated"
fi

# The script completed successfully --------------------------------------------
echo "[SSHD Keygen] Script completed successfully"

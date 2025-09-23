#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

dnf --assumeyes install restic

dnf --assumeyes remove \
	amd-gpu-firmware \
	amd-ucode-firmware \
	nano \
	nano-default-editor \
	flatpak-session-helper \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-issuegen \
	NetworkManager-cloud-setup \
	toolbox \
	nvidia-gpu-firmware

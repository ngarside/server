#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

rpm-ostree install hyperv-daemons restic

rpm-ostree override remove \
	amd-gpu-firmware \
	amd-ucode-firmware \
	nano \
	nano-default-editor \
	flatpak-session-helper \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-issuegen \
	moby-engine \
	moby-filesystem \
	NetworkManager-cloud-setup \
	rsync \
	toolbox \
	nvidia-gpu-firmware

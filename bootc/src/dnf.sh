#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

dnf --assumeyes install restic

dnf --assumeyes remove \
	adwaita-mono-fonts \
	adwaita-sans-fonts \
	amd-gpu-firmware \
	amd-ucode-firmware \
	bash-completion \
	bluez \
	cloud-utils-growpart \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-issuegen \
	nano \
	nano-default-editor \
	flatpak-session-helper \
	fonts-filesystem \
	NetworkManager-cloud-setup \
	NetworkManager-tui \
	ntfs* \
	qemu-user-static* \
	python-pip-wheel \
	python3 \
	python3-libs \
	rpm-ostree* \
	samba* \
	sudo-python-plugin \
	toolbox \
	nvidia-gpu-firmware

dnf clean all

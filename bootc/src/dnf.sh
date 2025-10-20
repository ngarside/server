#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

dnf --assumeyes install restic

dnf --assumeyes remove \
	adwaita-mono-fonts \
	adwaita-sans-fonts \
	atheros-firmware \
	amd-gpu-firmware \
	amd-ucode-firmware \
	bash-completion \
	bluez \
	brcmfmac-firmware \
	cirrus-audio-firmware \
	cloud-utils-growpart \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-issuegen \
	dosfs* \
	exfatprogs \
	f2fs* \
	fedora-repos-archive \
	hwdata \
	logrotate \
	mt7xxx-firmware \
	nano \
	nano-default-editor \
	nilfs* \
	nxpwireless-firmware \
	flatpak-session-helper \
	fonts-filesystem \
	gsettings-desktop-schemas \
	NetworkManager-cloud-setup \
	NetworkManager-tui \
	ntfs* \
	qcom-wwan-firmware \
	qemu-user-static* \
	python-pip-wheel \
	python3 \
	python3-libs \
	rpm-ostree* \
	samba* \
	sudo-python-plugin \
	tiwilink-firmware \
	toolbox \
	nvidia-gpu-firmware

dnf clean all

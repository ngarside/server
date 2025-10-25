#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

dnf --assumeyes install restic

dnf --assumeyes remove \
	adwaita-mono-fonts \
	adwaita-sans-fonts \
	amd-gpu-firmware \
	amd-ucode-firmware \
	atheros-firmware \
	avahi \
	bash-completion \
	bind-utils \
	bluez \
	brcmfmac-firmware \
	cirrus-audio-firmware \
	cloud-utils-growpart \
	console-login-helper-messages \
	console-login-helper-messages-issuegen \
	console-login-helper-messages-profile \
	dosfs* \
	exfatprogs \
	f2fs* \
	fedora-repos-archive \
	flatpak-session-helper \
	fonts-filesystem \
	gawk-all-langpacks \
	gsettings-desktop-schemas \
	hwdata \
	json-glib \
	libjcat \
	logrotate \
	mt7xxx-firmware \
	nano \
	nano-default-editor \
	NetworkManager-cloud-setup \
	NetworkManager-tui \
	newt \
	nilfs* \
	ntfs* \
	nvidia-gpu-firmware \
	nxpwireless-firmware \
	python-pip-wheel \
	python3 \
	python3-libs \
	qcom-wwan-firmware \
	qemu-user-static* \
	rpm-ostree* \
	samba* \
	sg3_utils* \
	slang \
	sudo-python-plugin \
	tiwilink-firmware \
	toolbox \
	xkeyboard-config

dnf clean all

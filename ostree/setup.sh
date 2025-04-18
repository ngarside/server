#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

systemctl enable adguardhome
systemctl enable caddy

echo server > /usr/etc/hostname

rpm-ostree install hyperv-daemons

rpm-ostree override remove \
	afterburn-dracut \
	amd-gpu-firmware \
	amd-ucode-firmware \
	coreos-installer \
	coreos-installer-bootinfra \
	docker-cli \
	nano \
	nano-default-editor \
	flatpak-session-helper \
	git-core \
	ignition \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-motdgen \
	console-login-helper-messages-issuegen \
	google-compute-engine-guest-configs-udev \
	moby-engine \
	moby-filesystem \
	NetworkManager-cloud-setup \
	rsync \
	toolbox \
	nvidia-gpu-firmware

	# doesn't work, don't know why
	# samba-client-libs \
	# samba-common \
	# samba-common-libs \
	# sssd-ipa \
	# sssd-common-pac \
	# sssd-ad \
	# cifs-utils \
	# libsmbclient \
	# libwbclient \

ostree container commit

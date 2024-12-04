#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/images

podman pull ghcr.io/ngarside/adguardhome:latest
podman save --output /etc/images/adguardhome ghcr.io/ngarside/adguardhome:latest

chown --recursive containers:containers /etc/images
chmod --recursive ug=r,o= /etc/images

podman image prune --all --force

systemctl enable adguardhome

systemctl disable systemd-resolved

echo server > /usr/etc/hostname

rpm-ostree override remove \
	coreos-installer \
	coreos-installer-bootinfra \
	nano \
	nano-default-editor \
	git-core \
	ignition \
	console-login-helper-messages \
	console-login-helper-messages-profile \
	console-login-helper-messages-motdgen \
	console-login-helper-messages-issuegen \
	moby-engine \
	rsync \
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

# must be last so pulling images still works
# doesn't work, don't know why
# rpm-ostree override remove systemd-resolved

ostree container commit

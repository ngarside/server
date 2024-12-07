#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/images

podman pull ghcr.io/ngarside/adguardhome:latest
podman pull ghcr.io/ngarside/caddy:latest
podman pull ghcr.io/ngarside/gitea:latest

podman save --output /etc/images/adguardhome ghcr.io/ngarside/adguardhome:latest
podman save --output /etc/images/caddy ghcr.io/ngarside/caddy:latest
podman save --output /etc/images/gitea ghcr.io/ngarside/gitea:latest

# The owner can't be changed to the 'containers' user as they don't exist when
#   the OSTree image is created, so instead allow all users to read the images.
#   Doing this recursively for all files in the '/etc/images' directory doesn't
#   work, needs investigation.
chmod ugo=r /etc/images/adguardhome
chmod ugo=r /etc/images/caddy
chmod ugo=r /etc/images/gitea

podman image prune --all --force

systemctl enable adguardhome
systemctl enable caddy

systemctl disable systemd-resolved

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

# must be last so pulling images still works
# doesn't work, don't know why
# rpm-ostree override remove systemd-resolved

ostree container commit

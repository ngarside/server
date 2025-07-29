#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/caddy
mkdir --parents /usr/etc/containers/systemd/users/1001
mkdir --parents /usr/etc/restic
mkdir --parents /usr/etc/ssh/authorized_keys
mkdir --parents /usr/etc/ssh/sshd_config.d
mkdir --parents /usr/etc/sysctl.d
mkdir --parents /usr/etc/systemd/resolved.conf.d

cp /tmp/git/sshd/ops/authorizedkeys.conf /usr/etc/ssh/sshd_config.d/20-authorizedkeys.conf
cp /tmp/git/sshd/ops/hardening.conf /usr/etc/ssh/sshd_config.d/10-hardening.conf
cp /tmp/git/sshd/ops/authorizedkeys.pub /usr/etc/ssh/authorized_keys/core

cp /tmp/git/adguardhome/ops/adguardhome.container /usr/etc/containers/systemd/users/1001/adguardhome.container
cp /tmp/git/adguardhome/ops/adguardhome.network /usr/etc/containers/systemd/users/1001/adguardhome.network
cp /tmp/git/adguardhome/ops/stub.conf /usr/etc/systemd/resolved.conf.d/stub.conf

cp /tmp/git/caddy/ops/caddyfile /etc/caddy/caddyfile

cp /tmp/git/ostree/ops/vconsole.conf /usr/etc/vconsole.conf

cp /tmp/git/ostree/ops/sysctl.conf /usr/etc/sysctl.d/0-server.conf

cp /tmp/git/ostree/ops/subuid.txt /usr/etc/subuid

cp /tmp/git/podman/ops/policy.json /usr/etc/containers/policy.json

cp /tmp/git/restic/src/restic.env /usr/etc/restic/restic.env
cp /tmp/git/restic/src/restic.sh /usr/etc/restic/restic.sh
cp /tmp/git/restic/ops/restic.service /usr/lib/systemd/system/restic.service
cp /tmp/git/restic/ops/restic.timer /usr/lib/systemd/system/restic.timer

cp /tmp/git/fossflow/ops/fossflow.container /usr/etc/containers/systemd/users/1001/fossflow.container
cp /tmp/git/fossflow/ops/fossflow.network /usr/etc/containers/systemd/users/1001/fossflow.network

mkdir /usr/etc/starbase
cp /tmp/git/starbase/ops/starbase.json /usr/etc/starbase/starbase.json
cp /tmp/git/starbase/ops/starbase.container /usr/etc/containers/systemd/users/1001/starbase.container
cp /tmp/git/starbase/ops/starbase.network /usr/etc/containers/systemd/users/1001/starbase.network

cp /tmp/git/memos/ops/memos.container /usr/etc/containers/systemd/users/1001/memos.container
cp /tmp/git/memos/ops/memos.network /usr/etc/containers/systemd/users/1001/memos.network

cp /tmp/git/caddy/ops/caddy.container /usr/etc/containers/systemd/users/1001/caddy.container

cp /tmp/git/penpot/ops/backend.container /usr/etc/containers/systemd/users/1001/penpot_backend.container
cp /tmp/git/penpot/ops/exporter.container /usr/etc/containers/systemd/users/1001/penpot_exporter.container
cp /tmp/git/penpot/ops/frontend.container /usr/etc/containers/systemd/users/1001/penpot_frontend.container
cp /tmp/git/penpot/ops/postgres.container /usr/etc/containers/systemd/users/1001/penpot_postgres.container
cp /tmp/git/penpot/ops/valkey.container /usr/etc/containers/systemd/users/1001/penpot_valkey.container
cp /tmp/git/penpot/ops/penpot_backend.network /usr/etc/containers/systemd/users/1001/penpot_backend.network
cp /tmp/git/penpot/ops/penpot_frontend.network /usr/etc/containers/systemd/users/1001/penpot_frontend.network

systemctl enable restic.timer

chmod ug=r,o= /usr/etc/restic/restic.{env,sh}

echo server > /usr/etc/hostname

rpm-ostree install hyperv-daemons restic

rpm-ostree override remove \
	afterburn-dracut \
	amd-gpu-firmware \
	amd-ucode-firmware \
	cifs-utils \
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

ostree container commit

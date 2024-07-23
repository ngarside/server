# This is free and unencumbered software released into the public domain.

mkdir --parents /etc/images

podman pull ghcr.io/ngarside/adguardhome:latest
podman save --output /etc/images/adguardhome ghcr.io/ngarside/adguardhome:latest
chmod ug=r,o= /etc/images/adguardhome

mkdir --parents /etc/adguardhome/{conf,work}
chmod --recursive u=rwx,g=rx,o= /etc/adguardhome
systemctl enable adguardhome

systemctl disable systemd-resolved

rpm-ostree override remove \
	coreos-installer \
	coreos-installer-bootinfra \
	nano \
	nano-default-editor \
	git-core
	# console-login-helper-messages \
	# console-login-helper-messages-profile \
	# console-login-helper-messages-motdgen \
	# console-login-helper-messages-issuegen \
	# moby-engine \
	# rsync \
	# samba-client-libs \
	# samba-common \
	# samba-common-libs \
	# sssd-ipa \
	# sssd-common-pac \
	# sssd-ad \
	# cifs-utils \
	# libsmbclient \
	# libwbclient \
	# ignition \
	# nvidia-gpu-firmware

# must be last so pulling images still works
# doesn't work, don't know why
# rpm-ostree override remove systemd-resolved

ostree container commit

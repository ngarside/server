# This is free and unencumbered software released into the public domain.

mkdir --parents /etc/images

podman pull ghcr.io/ngarside/adguardhome:latest
podman save --output /etc/images/adguardhome ghcr.io/ngarside/adguardhome:latest
chmod ug=r,o= /etc/images/adguardhome

mkdir --parents /etc/adguardhome/{conf,work}
chmod --recursive u=rwx,g=rx,o= /etc/adguardhome
systemctl enable adguardhome

systemctl disable systemd-resolved

# useradd --system containers
# useradd --shell /usr/bin/false containers
# useradd --no-create-home --shell /usr/bin/false containers
# echo containers:2147483647:2147483648 >> /etc/subuid
# echo containers:2147483647:2147483648 >> /etc/subgid

rpm-ostree override remove coreos-installer coreos-installer-bootinfra nano nano-default-editor

# must be last so pulling images still works
# doesn't work, don't know why
# rpm-ostree override remove systemd-resolved

ostree container commit

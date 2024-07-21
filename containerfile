# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora-coreos:stable

# COPY ./adguardhome/adguardconf.yaml /etc/adguardhome/conf/AdGuardHome.yaml
COPY ./adguardhome/adguardhome.service /usr/lib/systemd/system/adguardhome.service

COPY ./setup.sh /tmp/setup

RUN chmod +x /tmp/setup && /tmp/setup && rm --force /tmp/setup

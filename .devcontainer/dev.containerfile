# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora:43

RUN dnf --assumeyes --setopt=install_weak_deps=false install git python3-pip

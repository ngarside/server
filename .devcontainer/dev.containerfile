# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora:43

RUN << EOF
	dnf --assumeyes --setopt=install_weak_deps=false install \
		fuse-overlayfs git go-task podman python3-pip

	echo "root:10000:5000" > /etc/subgid
	echo "root:10000:5000" > /etc/subuid

	cat > /usr/bin/task <<- 'INR'
		#!/usr/bin/env sh
		go-task "$@"
	INR

	chmod +x /usr/bin/task
EOF

VOLUME /var/lib/containers

ADD https://raw.githubusercontent.com/containers/image_build/refs/heads/main/podman/containers.conf /etc/containers/containers.conf

# This is free and unencumbered software released into the public domain.

# This container, among other things, allows running podman within podman.
# - https://github.com/containers/image_build/tree/main/podman
# - https://redhat.com/en/blog/podman-inside-container

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

	cat > /etc/containers/containers.conf <<- 'INR'
		[containers]
		cgroupns = "host"
		cgroups = "disabled"
		ipcns = "host"
		log_driver = "k8s-file"
		netns = "host"
		userns = "host"
		utsns = "host"

		[engine]
		cgroup_manager = "cgroupfs"
		events_logger = "file"
		runtime = "crun"
	INR
EOF

VOLUME /var/lib/containers

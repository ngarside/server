# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora:43

# Install dependencies.
RUN << EOF
	dnf --assumeyes --setopt=install_weak_deps=false install \
		caddy fuse-overlayfs git go-task podman python3-pip
	mv /usr/bin/go-task /usr/bin/task
EOF

# Allow running podman within the container.
# - https://github.com/containers/image_build/tree/main/podman
# - https://redhat.com/en/blog/podman-inside-container
RUN << EOF
	echo "root:10000:5000" > /etc/subgid
	echo "root:10000:5000" > /etc/subuid
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

# Setup rootless user.
RUN << EOF
	useradd --groups wheel dev
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/dev
	chmod 0440 /etc/sudoers.d/dev
EOF
USER dev

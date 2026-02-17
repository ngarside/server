# This is free and unencumbered software released into the public domain.

# Build customised caddy install.
FROM docker.io/caddy:2.10.2-builder-alpine AS caddy
RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http

# Install dependencies.
FROM quay.io/fedora/fedora:43@sha256:32af823de368e898d82b7650a3082d25697dbadfd266c400b5b01d78be9351de
HEALTHCHECK CMD ["/bin/true"]
COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
RUN <<EOF
	dnf --assumeyes --setopt=install_weak_deps=false install \
		diffutils fuse-overlayfs git gh go-task \
		jq openssl optipng patch podman python3-pip
	dnf clean all
	mv /usr/bin/go-task /usr/bin/task
EOF

# Setup rootless user.
RUN <<EOF
	useradd --groups wheel dev
	echo "dev:10000:5000" | tee /etc/subgid /etc/subuid
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudo
	chmod 0440 /etc/sudoers.d/sudo
EOF

# Allow running podman within the container.
# - https://github.com/containers/image_build/tree/main/podman
# - https://redhat.com/en/blog/podman-inside-container
RUN <<EOF
	rpm --restore shadow-utils
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
	sudo -u dev mkdir --parents /home/dev/.config/containers
	cat > /home/dev/.config/containers/containers.conf <<- 'INR'
		[containers]
		volumes = ["/proc:/proc"]
	INR
	cat > /home/dev/.config/containers/storage.conf <<- 'INR'
		[storage]
		driver = "overlay"
		[storage.options.overlay]
		ignore_chown_errors = "true"
	INR
EOF

# Finalise setup.
USER dev

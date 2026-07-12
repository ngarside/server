# This is free and unencumbered software released into the public domain.

# Build customised caddy install.
FROM docker.io/caddy:2.11.4-builder-alpine@sha256:8e89605351333ad2cc2f3bcc95275a2ccc427f88914050e86a5fde0fd77a63c4 AS caddy
RUN xcaddy build \
	--with github.com/caddy-dns/cloudflare \
	--with github.com/hslatman/caddy-crowdsec-bouncer/http

# Install dependencies.
FROM quay.io/fedora/fedora:44@sha256:dde4f63cf8b0f57ffb62fe16b32ced482d17a9a0ea97f8f532caf387a108afc2
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

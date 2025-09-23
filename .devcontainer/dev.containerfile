# This is free and unencumbered software released into the public domain.

FROM quay.io/fedora/fedora:44

RUN << EOF
	dnf --assumeyes --setopt=install_weak_deps=false install git go-task python3-pip

	cat > /usr/bin/task <<- 'INR'
		#!/usr/bin/env sh

		go-task "$@"
	INR

	chmod +x /usr/bin/task
EOF

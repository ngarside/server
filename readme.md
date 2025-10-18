<!-- This is free and unencumbered software released into the public domain -->

![Server](media/header.webp)

<p align=center>
	<img src=https://img.shields.io/github/last-commit/ngarside/server?color=red&style=for-the-badge>
	&nbsp;
	<img src=https://img.shields.io/github/license/ngarside/server?color=brightgreen&style=for-the-badge>
	&nbsp;
	<img src=https://img.shields.io/github/languages/top/ngarside/server?color=blue&style=for-the-badge>
</p>

This repo contains the entire codebase used to configure and run my home server.
The server itself is a simple, single node container host.
It is based on Fedora Bootc and uses Podman Quadlet for orchestration.

# <p align=center>Map

This repo is structured as a monorepo and contains various related projects:

- Build, test and orchestration scripts for various containers
- Build scripts for the Bootc base image
- Python helper scripts, primarily for use within CI/CD
- Build scripts for an auto-install ISO image

See the readme file in each top-level folder for further information on individual projects.

# <p align=center>Security

The various containers are reasonably well hardened, however this hardening is
split between the container files and the systemd services. Therefore, it is not
recommended to run the containers in other environments, as they will only be
partially hardened.

# <p align=center>License

This is free and unencumbered software released into the public domain.

Some files are vendored from other projects and have different licenses.
Check the individual file headers for more details.

The [header image](media/header.webp) is licensed from the
[Lightsaber Collection](https://unsplash.com/photos/T-IN5o3kxyA).

#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

groupadd nathan
adduser nathan --gid nathan --groups wheel \
	--password '$y$j9T$OLuRa6z/r.NzsUb0EaGvM/$mut9ROWI86bV1F.iEPxzhI6UjlNr2BDpKxi0d1wC7b1'

groupadd containers
adduser containers --gid containers --groups systemd-journal

mkdir --parents /var/lib/systemd/linger
touch /var/lib/systemd/linger/containers
chmod 0644 /var/lib/systemd/linger/containers

find /var/home -maxdepth 2 -type f -name '.bash*' -exec rm {} \;

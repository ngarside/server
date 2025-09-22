#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/restic

cp /tmp/git/restic/src/restic.env /etc/restic/restic.env
cp /tmp/git/restic/src/restic.sh /etc/restic/restic.sh
cp /tmp/git/restic/ops/restic.service /usr/lib/systemd/system/restic.service
cp /tmp/git/restic/ops/restic.timer /usr/lib/systemd/system/restic.timer

systemctl enable restic.timer

chmod ug=r,o= /etc/restic/restic.{env,sh}

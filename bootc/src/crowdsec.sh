#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/crowdsec
mkdir --parents /etc/containers/systemd/users/1001

cp /git/crowdsec/ops/crowdsec.yaml /etc/crowdsec/acquis.yaml
cp /git/crowdsec/ops/* /etc/containers/systemd/users/1001/

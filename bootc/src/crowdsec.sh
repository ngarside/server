#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/crowdsec
mkdir --parents /etc/containers/systemd/users/1001

cp --recursive /git/crowdsec/ops/configuration/* /etc/crowdsec/
cp --recursive /git/crowdsec/ops/containers/* /etc/containers/systemd/users/1001/
cp --recursive /git/crowdsec/ops/networks/* /etc/containers/systemd/users/1001/

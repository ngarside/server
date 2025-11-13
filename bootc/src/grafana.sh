#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/grafana
cp /git/grafana/ops/grafana.ini /etc/grafana/grafana.ini

mkdir --parents /etc/containers/systemd/users/1001
cp /git/grafana/ops/grafana.container /etc/containers/systemd/users/1001/grafana.container
cp /git/grafana/ops/grafana.network /etc/containers/systemd/users/1001/grafana.network

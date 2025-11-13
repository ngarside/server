#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001

cp /git/victoria/ops/containers/logs.container /etc/containers/systemd/users/1001/victoria_logs.container
cp /git/victoria/ops/containers/metrics.container /etc/containers/systemd/users/1001/victoria_metrics.container

cp /git/victoria/ops/networks/logs.network /etc/containers/systemd/users/1001/victoria_logs.network
cp /git/victoria/ops/networks/metrics.network /etc/containers/systemd/users/1001/victoria_metrics.network

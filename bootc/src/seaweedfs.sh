#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/containers/systemd/users/1001
cp /git/seaweedfs/ops/seaweedfs.container /etc/containers/systemd/users/1001/seaweedfs.container
cp /git/seaweedfs/ops/seaweedfs.network /etc/containers/systemd/users/1001/seaweedfs.network

mkdir --parents /etc/seaweedfs
cp /git/seaweedfs/ops/seaweedfs.json /etc/seaweedfs/seaweedfs.json

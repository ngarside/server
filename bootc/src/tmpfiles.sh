#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

mkdir --parents /etc/tmpfiles.d
cp /git/bootc/ops/tmpfiles/nathan.conf /etc/tmpfiles.d/nathan.conf

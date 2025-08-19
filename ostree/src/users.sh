#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

groupadd core
adduser core --gid core --groups wheel

groupadd containers
adduser containers --gid containers --groups systemd-journal

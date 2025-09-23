#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

setsebool -P container_read_certs true

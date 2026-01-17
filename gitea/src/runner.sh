#!/usr/bin/env sh
# This is free and unencumbered software released into the public domain.

set -emu

# Register the Gitea runner ------------------------------------------------------------------------
echo "[CONFIG] Registering runner"
runner register

# Start the Gitea runner ---------------------------------------------------------------------------
echo "[CONFIG] Starting runner"
runner daemon

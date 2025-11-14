#!/usr/bin/env sh
# This is free and unencumbered software released into the public domain.

# Custom entrypoint which starts a configuration script in the background
# before calling the original entrypoint.

set -eu

/usr/bin/configuration &
/usr/bin/gitea --config /etc/gitea/gitea.ini "$@"

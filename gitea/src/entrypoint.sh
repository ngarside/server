#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

# Custom entrypoint which starts a configuration script in the background
# before calling the original entrypoint.

set -euo pipefail

/usr/bin/configuration &
/usr/bin/telae /etc/gitea/tmpl/gitea.tmpl /etc/gitea/conf/gitea.ini
/usr/bin/gitea --config /etc/gitea/conf/gitea.ini "$@"

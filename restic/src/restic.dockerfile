# This is free and unencumbered software released into the public domain.

FROM ghcr.io/restic/restic:0.19.0@sha256:9b0c3c7010d79826a67731ea91a8d1b7eb308d255bdb50a984dbed3e50100deb AS restic

FROM scratch
COPY --from=restic /usr/bin/restic /usr/bin/restic
ENTRYPOINT ["/usr/bin/restic"]

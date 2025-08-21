# This is free and unencumbered software released into the public domain.

FROM ghcr.io/restic/restic:0.18.0 AS restic

FROM scratch

COPY --from=restic /usr/bin/restic /usr/bin/restic

ENTRYPOINT ["/usr/bin/restic"]

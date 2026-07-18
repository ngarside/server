# This is free and unencumbered software released into the public domain.

FROM ghcr.io/restic/restic:0.19.1@sha256:2f0373803493361f9304a57150d464677f69a9dad487afec202105aafb2592f2 AS restic

FROM scratch
COPY --from=restic /usr/bin/restic /usr/bin/restic
ENTRYPOINT ["/usr/bin/restic"]

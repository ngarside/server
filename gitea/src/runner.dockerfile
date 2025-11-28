# This is free and unencumbered software released into the public domain.

FROM docker.io/gitea/act_runner:0.2.13 AS runner

FROM scratch
COPY --from=runner /usr/local/bin/act_runner /usr/bin/runner
ENTRYPOINT ["/usr/bin/runner"]
CMD ["daemon"]

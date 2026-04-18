# This is free and unencumbered software released into the public domain.

# The upstream reference is duplicated as it both:
# - Needs to appear first to be detected as the upstream tag
# - Needs to appear last to be inherited from

FROM docker.io/timberio/vector:0.54.0-debian@sha256:099732c890b095d5222f59bdc82a0579ae3d48b9e2407f3680586dd8d2f75f64

FROM docker.io/alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11 AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM docker.io/timberio/vector:0.54.0-debian@sha256:099732c890b095d5222f59bdc82a0579ae3d48b9e2407f3680586dd8d2f75f64
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/vector"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8686/health"]
CMD ["--config", "/etc/vector/*.toml"]

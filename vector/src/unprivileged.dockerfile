# This is free and unencumbered software released into the public domain.

FROM docker.io/timberio/vector:0.54.0-distroless-static@sha256:29755320d6f7a6fbd87ddda0d84272cb6922862650e8ab7105192734f4e1bb6c AS vector

FROM docker.io/alpine:3.23.4@sha256:c7989ac7a27b473e1795973c98d714f62b4dd0b134594d36880505ce0bfd716b AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=vector /usr/local/bin/vector /usr/bin/vector
COPY --from=headcheck /headcheck /usr/bin/headcheck
ENTRYPOINT ["/usr/bin/vector"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:8686/health"]
CMD ["--config", "/etc/vector/*.toml"]

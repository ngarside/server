# This is free and unencumbered software released into the public domain.

# This file downloads the OpenCloud GitHub release as it is statically compiled, whereas
# the Docker release is dynamically compiled due to including libvips support. The Docker
# image is still referenced to support automated dependency updates.
# https://github.com/opencloud-eu/opencloud/tree/main/services/thumbnails

FROM docker.io/opencloudeu/opencloud-rolling:7.3.0@sha256:f988f14779cbfe26dec78ea3fc2492ae063fe14a069857dd2d5a397a927fc361 AS opencloud
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
WORKDIR /
RUN apk --no-cache add grep
RUN (opencloud version || true) | grep -oP '(?<=Version: )\S*' > /version
RUN echo "v$(cat /version)/opencloud-$(cat /version)-linux-amd64" >> /release
RUN wget "https://github.com/opencloud-eu/opencloud/releases/download/$(cat /release)"
RUN mv "/opencloud-$(cat /version)-linux-amd64" /opencloud
RUN chmod ugo=rx /opencloud

FROM docker.io/alpine:3.24.1@sha256:28bd5fe8b56d1bd048e5babf5b10710ebe0bae67db86916198a6eec434943f8b AS headcheck
RUN wget https://github.com/pixelatedlabs/headcheck/releases/download/3.0.0/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=opencloud /opencloud /usr/bin/opencloud
CMD ["server"]
ENTRYPOINT ["/usr/bin/opencloud"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:9200/status"]

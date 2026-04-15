# This is free and unencumbered software released into the public domain.

# This file downloads the OpenCloud GitHub release as it is statically compiled, whereas
# the Docker release is dynamically compiled due to including libvips support. The Docker
# image is still referenced to support automated dependency updates.
# https://github.com/opencloud-eu/opencloud/tree/main/services/thumbnails

FROM docker.io/opencloudeu/opencloud-rolling:6.0.0@sha256:283b1df495bd7c8571868bb8662336cc6e6fe3078b0bf907955651f245cf938f AS opencloud
SHELL ["/bin/ash", "-euo", "pipefail", "-c"]
USER root
WORKDIR /
RUN apk --no-cache add grep
RUN (opencloud version || true) | grep -oP '(?<=Version: )\S*' > /version
RUN echo "v$(cat /version)/opencloud-$(cat /version)-linux-amd64" >> /release
RUN wget "https://github.com/opencloud-eu/opencloud/releases/download/$(cat /release)"
RUN mv "/opencloud-$(cat /version)-linux-amd64" /opencloud
RUN chmod ugo=rx /opencloud

FROM docker.io/alpine:3.23.4@sha256:c7989ac7a27b473e1795973c98d714f62b4dd0b134594d36880505ce0bfd716b AS headcheck
RUN wget https://pixelatedlabs.com/headcheck/releases/latest/linux-x64.zip
RUN unzip /linux-x64.zip

FROM scratch
COPY --from=headcheck /headcheck /usr/bin/headcheck
COPY --from=opencloud /opencloud /usr/bin/opencloud
CMD ["server"]
ENTRYPOINT ["/usr/bin/opencloud"]
HEALTHCHECK CMD ["/usr/bin/headcheck", "http://0.0.0.0:9200/status"]

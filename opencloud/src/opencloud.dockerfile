# This is free and unencumbered software released into the public domain.

# This file downloads the OpenCloud GitHub release as it is statically compiled, whereas
# the Docker release is dynamically compiled due to including libvips support. The Docker
# image is still referenced to support automated dependency updates.
# https://github.com/opencloud-eu/opencloud/tree/main/services/thumbnails

FROM docker.io/opencloudeu/opencloud-rolling:3.5.0 AS opencloud
USER root
RUN apk --no-cache add grep
RUN opencloud version | grep --only-matching --perl-regexp '(?<=Version: )\S*' >> /version
RUN echo "v$(cat /version)/opencloud-$(cat /version)-linux-amd64" >> /release
RUN wget https://github.com/opencloud-eu/opencloud/releases/download/$(cat /release)
RUN mv /var/lib/opencloud/opencloud-$(cat /version)-linux-amd64 /opencloud
RUN chmod ugo=rx /opencloud
USER 1000

FROM scratch
COPY --from=opencloud /opencloud /usr/bin/opencloud
ENTRYPOINT ["/usr/bin/opencloud"]
CMD ["server"]

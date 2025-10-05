# This is free and unencumbered software released into the public domain.

FROM docker.io/opencloudeu/opencloud-rolling:3.5.0 AS version
USER root
RUN apk --no-cache add grep
RUN opencloud version | grep --only-matching --perl-regexp '(?<=Version: )\S*' >> /version

FROM docker.io/alpine:3.22.1 AS opencloud
COPY --from=version /version /version
RUN wget https://github.com/opencloud-eu/opencloud/releases/download/v$(cat /version)/opencloud-$(cat /version)-linux-amd64
RUN mv /opencloud-$(cat /version)-linux-amd64 /opencloud
RUN chmod ugo=rx /opencloud

FROM scratch
COPY --from=opencloud /opencloud /usr/bin/opencloud
ENTRYPOINT ["/usr/bin/opencloud"]
CMD ["server"]

# This is free and unencumbered software released into the public domain.

FROM docker.io/alpine:latest@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1 AS build

RUN apk add git

# gitea --version | grep -oE [0-9]+.[0-9]+.[0-9]+
RUN wget -O gitea https://dl.gitea.com/gitea/1.24.3/gitea-1.24.3-linux-amd64
RUN chmod +x gitea

RUN echo "gitea:x:100:101::/usr/bin/data/home:/sbin/nologin" >> /tmp/passwd

FROM scratch

COPY --from=build /gitea /usr/bin/gitea

COPY --from=build /usr/bin/git /usr/bin/git

COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=build /usr/lib/libpcre2-8.so.0 /usr/lib/libpcre2-8.so.0

COPY --from=build /usr/lib/libz.so.1 /usr/lib/libz.so.1

COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1

COPY --from=build /tmp/passwd /etc/passwd

ENV GITEA_I_AM_BEING_UNSAFE_RUNNING_AS_ROOT=true

ENV APP_DATA_PATH=/opt/gitea

# RUN gitea:x:100:101::/home/gitea:/sbin/nologin

USER gitea

EXPOSE 80

ENTRYPOINT ["/usr/bin/gitea"]

CMD ["web", "--config", "/usr/bin/data/etc/gitea.ini", "--port", "80"]

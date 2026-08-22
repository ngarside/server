# This is free and unencumbered software released into the public domain.

# This file was adapted under the LGPL-3.0 license
# https://github.com/ZoeyVid/valkey-static/blob/latest/Dockerfile
# https://github.com/ZoeyVid/valkey-static/blob/latest/COPYING

FROM docker.io/valkey/valkey:9.1.1@sha256:70739f85ad2ee01a726a965584a0f94895f01b0c60b3cc8b0aeef11eaa6888cf
HEALTHCHECK CMD ["valkey-cli", "ping"]
CMD ["--protected-mode", "no", "--save"]

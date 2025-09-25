<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Outline

Scripts for running Outline via Podman and Systemd.

# <p align=center>Manual Setup

Before running Outline for the first time on a system, you must first run this command as the
containers user:

```sh
dd bs=96 count=1 if=/dev/urandom status=none \
| base64 --wrap 0 \
| podman secret create outline_oidc_secret -
```

# <p align=center>References

- [getoutline.com](https://getoutline.com)

# <p align=center>License

This is free and unencumbered software released into the public domain.

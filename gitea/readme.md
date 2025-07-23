<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Gitea

A hardened container image and associated scripts for running Gitea via
Podman and Systemd.

# <p align=center>Initial Setup

When configuring Gitea for the first time, the paths should be set as follows:

| Setting      | Path                       |
|--------------|----------------------------|
| Database     | /usr/bin/data/db/gitea     |
| LFS          | /usr/bin/data/lfs          |
| Logs         | /var/log                   |
| Repositories | /usr/bin/data/git          |

# <p align=center>References

- [gitea.com](https://gitea.com)
- [github.com/go-gitea/gitea](https://github.com/go-gitea/gitea)

# <p align=center>License

This is free and unencumbered software released into the public domain.

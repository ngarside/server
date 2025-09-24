<!-- This is free and unencumbered software released into the public domain -->

# <p align=center>Outline

Scripts for running Outline via Podman and Systemd.

# <p align=center>Manual Setup

Before running Outline for the first time on a system, these steps need to be
performed manually:

- Copy the client secret from the Outline Provider in Authentik
- Run this command as the containers user, using the client secret copied above
  ```sh
  echo -n 'CLIENTSECRET' | podman secret create outline_oidc_secret -
  ```

# <p align=center>References

- [getoutline.com](https://getoutline.com)

# <p align=center>License

This is free and unencumbered software released into the public domain.

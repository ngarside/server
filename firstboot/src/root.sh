# This is free and unencumbered software released into the public domain.

# On first boot, this script must be modified to include the appropriate secret
# data and then run as the 'root' user.

# Restic.
echo -n 'SECRETDATA' | podman secret create restic_repository_key -
echo -n 'SECRETDATA' | podman secret create restic_repository_password -
echo -n 'SECRETDATA' | podman secret create restic_repository_secret -
echo -n 'SECRETDATA' | podman secret create restic_repository_uri -

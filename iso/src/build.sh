#!/usr/bin/env bash
# This is free and unencumbered software released into the public domain.

set -euo pipefail

# Create build directory -------------------------------------------------------

mkdir --parents bin

# Compile ignition file --------------------------------------------------------

docker run \
	--interactive \
	--rm \
	--volume .:/opt \
	quay.io/coreos/butane:release \
		--files-dir /opt \
		--pretty \
		--strict \
		< src/butane.yml \
		> bin/ignition.json

# Download latest ISO ----------------------------------------------------------

docker run \
	--interactive \
	--rm \
	--volume ./bin:/opt \
	quay.io/coreos/coreos-installer:release \
	download --directory /opt --format iso

mv bin/*.iso bin/original.iso
mv bin/*.iso.sig bin/original.iso.sig

# Customise ISO ----------------------------------------------------------------

cp ops/wipe.sh bin/wipe.sh

docker run \
	--interactive \
	--rm \
	--volume ./bin:/opt quay.io/coreos/coreos-installer:release \
		iso customize \
		--dest-device /dev/sda \
		--dest-ignition /opt/ignition.json \
		--output /opt/server.iso \
		--pre-install /opt/wipe.sh \
		/opt/original.iso

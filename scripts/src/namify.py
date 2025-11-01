#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Calculates the name of the given image description:
# - Images are always placed at 'ghcr.io/ngarside/<name>'
# - If the file and root folder have the same name then the image name will be '<file-name>'
# - Otherwise the image name will be '<root-name>-<file-name>'

# Run with 'python namify.py <path>'

import pathlib, sys

if __name__ == '__main__':
	# Assert CLI argument usage.
	if len(sys.argv) != 2:
		print('Usage: python tagify.py <path>')
		sys.exit(2)

	# Parse the provided path.
	path = pathlib.Path(sys.argv[1])
	image = path.stem
	service = path.parts[0]

	# If the image and service match then use the short syntax.
	if image == service:
		print(f'ghcr.io/ngarside/{image}')
		sys.exit(0)

	# Otherwise use the full syntax.
	print(f'ghcr.io/ngarside/{service}-{image}')

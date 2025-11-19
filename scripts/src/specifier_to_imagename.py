#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

'''
	This tool transforms an image specifier into the name of its built image.
	Run with 'python specifier_to_imagename.py <specifier>'.

	| Specifier     | Standard Output                  |
	| ------------- | -------------------------------- |
	| service       | ghcr.io/ngarside/service         |
	| service/image | ghcr.io/ngarside/service-image   |
'''

import sys

def specifier_to_imagename(spec: str) -> str:
	parts = spec.split('/')

	# Specifier is in the format 'service'.
	if len(parts) == 1 and parts[0]:
		return f'ghcr.io/ngarside/{parts[0]}'

	# Specifier is in the format 'service/image'.
	elif len(parts) == 2 and all(part for part in parts):
		return f'ghcr.io/ngarside/{parts[0]}-{parts[1]}'

	# Specifier is an empty string.
	elif len(parts) == 1 and not parts[0]:
		raise ValueError('Missing specifier')

	# Specifier is in an unsupported format.
	raise ValueError(f'Invalid specifier <{spec}>')

if __name__ == '__main__':
	try:
		spec = (sys.argv + [''])[1]
		print(specifier_to_imagename(spec))
	except Exception as ex:
		print(__doc__[1:])
		print(f'Error: {str(ex)}', file=sys.stderr)
		sys.exit(1)

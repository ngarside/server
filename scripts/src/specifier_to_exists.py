#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

'''
	This tool checks whether an image with the given specifier has been created.
	Run with 'python specifier_to_exists.py <specifier>'.

	| Specifier  | Exit Code |
	| ---------- | --------- |
	| exists     | 0         |
	| not/exists | 1         |
'''

import os, specifier_to_dockerfile, sys

def specifier_to_exists(spec: str) -> int:
	dockerfile = specifier_to_dockerfile.specifier_to_dockerfile(spec)
	return 0 if os.path.exists(dockerfile) else 1

if __name__ == '__main__':
	try:
		spec = (sys.argv + [''])[1]
		sys.exit(specifier_to_exists(spec))
	except Exception as ex:
		print(__doc__[1:])
		print(f'Error: {str(ex)}', file=sys.stderr)
		sys.exit(1)

#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# This tool transforms an image specifier into the path of its dockerfile.
# Run with 'python specifier_to_dockerfile.py <specifier>'.

# | Specifier     | Standard Output                |
# | ------------- | ------------------------------ |
# | service       | service/src/service.dockerfile |
# | service/image | service/src/image.dockerfile   |

import sys

def specifier_to_dockerfile(spec: str) -> str:
	parts = spec.split('/')

	# Specifier is in the format 'service'.
	if len(parts) == 1 and parts[0]:
		return f'{parts[0]}/src/{parts[0]}.dockerfile'

	# Specifier is in the format 'service/image'.
	elif len(parts) == 2 and all(part for part in parts):
		return f'{parts[0]}/src/{parts[1]}.dockerfile'

	# Specifier is in an unsupported format.
	raise ValueError(f'Invalid specifier <{spec}>')

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print('Usage: python specifier_to_dockerfile.py <specifier>', file=sys.stderr)
		sys.exit(2)

	try:
		print(specifier_to_dockerfile(sys.argv[1]))
	except ValueError as ex:
		print(str(ex), file=sys.stderr)
		sys.exit(1)

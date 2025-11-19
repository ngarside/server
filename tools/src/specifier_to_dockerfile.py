#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# This tool transforms an image specifier into the path of its dockerfile.
# Run with 'python specifier_to_dockerfile.py <specifier>'

# | Specifier     | Standard Output                |
# | ------------- | ------------------------------ |
# | service       | service/src/service.dockerfile |
# | service/image | service/src/image.dockerfile   |

import argparse, sys

def specifier_to_dockerfile(spec: str) -> str:
	parts = spec.split('/')

	# Specifier is in the format 'service'.
	if len(parts) == 1 and parts[0]:
		return f'{parts[0]}/src/{parts[0]}.dockerfile'

	# Specifier is in the format 'service/image'.
	elif len(parts) == 2 and all(part for part in parts):
		return f'{parts[0]}/src/{parts[1]}.dockerfile'

	# Specifier is in an unsupported format.
	raise ValueError(
		f'Invalid specifier <{spec}> - expected format is <service> or <service/image>'
	)

if __name__ == '__main__':
	parser = argparse.ArgumentParser(
		description='Transforms an image specifier into the path of its dockerfile'
	)
	parser.add_argument(
		'spec',
		help='Service specification: <service> or <service/image>',
	)
	args = parser.parse_args()

	try:
		result = specifier_to_dockerfile(args.spec)
	except ValueError as exc:
		print(str(exc))
		sys.exit(1)

	print(result)

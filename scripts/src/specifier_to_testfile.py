#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys, textwrap

help = '''
	This tool transforms an image specifier into the path of its pytest file.
	Run with 'python specifier_to_testfile.py <specifier>'.

	| Specifier     | Standard Output         |
	| ------------- | ----------------------- |
	| service       | service/test/service.py |
	| service/image | service/test/image.py   |
'''

def specifier_to_testfile(spec: str) -> str:
	parts = spec.split('/')

	# Specifier is an empty string.
	if len(parts) == 1 and not parts[0]:
		raise ValueError('Missing specifier')

	# Specifier is in the format 'service'.
	elif len(parts) == 1 and parts[0]:
		return f'{parts[0]}/test/{parts[0]}.py'

	# Specifier is in the format 'service/image'.
	elif len(parts) == 2 and all(part for part in parts):
		return f'{parts[0]}/test/{parts[1]}.py'

	# Specifier is in an unsupported format.
	raise ValueError(f'Invalid specifier <{spec}>')

if __name__ == '__main__':
	try:
		spec = (sys.argv + [''])[1]
		print(specifier_to_testfile(spec))
	except Exception as ex:
		print(textwrap.dedent(help[1:]))
		print(f'Error: {str(ex)}', file=sys.stderr)
		sys.exit(1)

#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

# Sanitizes container tags by echoing the first CLI argument with alterations:
# - Replaces invalid characters with underscores
# - Trims boundary underscores
# - Merges consecutive underscores
# - Defaults to a single underscore if the tag contains no valid characters

# Run with 'python tag_sanitize.py <tag>'

import re, sys

def sanitize(tag):
	# Replace invalid characters with underscores.
	tag = re.sub(r'[^a-zA-Z0-9_.-]', '_', tag)

	# Trim boundary underscores.
	tag = re.sub(r'^[_]+(?=[^_])', '', tag)
	tag = re.sub(r'(?<=[^_])[_]+$', '', tag)

	# Merge consecutive underscores.
	tag = re.sub(r'_+', '_', tag)

	# Ensure the result is not empty.
	return tag if tag else '_'

if __name__ == '__main__':
	if len(sys.argv) != 2:
		print('Usage: python tag_sanitize.py <tag>')
		sys.exit(2)
	print(sanitize(sys.argv[1]))
	sys.exit(0)

try:
	import pytest
except ModuleNotFoundError:
	exit(0)

@pytest.mark.parametrize('input, expected', [
	('master', 'master'), # Normal branch name.
	('feature/new-branch:dev', 'feature_new-branch_dev'), # Special characters.
	('  my-branch   ', 'my-branch'), # Leading/trailing whitespace.
	('invalid/branch:name', 'invalid_branch_name'), # Mixed special chars.
	('', '_'), # Empty string.
	('!@#$%^&*()', '_'), # All invalid characters.
	('BranchWithUppercase', 'BranchWithUppercase'), # Uppercase preserved.
])

def test_sanitize(input, expected):
	assert sanitize(input) == expected

#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pathlib, sys

sys.path.append(str(pathlib.Path(__file__).parent.parent / 'src'))
import pytest, slugify

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
	assert slugify.sanitize(input) == expected

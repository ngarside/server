#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pathlib, pytest, sys

sys.path.append(str(pathlib.Path(__file__).parent.parent / 'src'))
import purge

@pytest.mark.parametrize('input, expected', [
	('', False),
	('latest', False),
	('feature_foo-bar', False),
	('1.2.3-alpine', False),

	('1', True),
	('1.2', True),
	('1.2.3', True),
	('1.2.3.4', True),

	('12', True),
	('12.34', True),
	('12.34.56', True),
	('12.34.56.78', True),
])

def test_is_semantic(input, expected):
	assert purge.is_semantic(input) == expected

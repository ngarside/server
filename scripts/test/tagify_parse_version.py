#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import pytest, tagify

@pytest.mark.parametrize('input, expected', [
	# Simple reference.
	('''
		# Header
		FROM foo:1.2.3
		RUN echo test
		FROM bar:4.5.6
	''', '1.2.3'),

	# Complex reference.
	('''
		# Header
		FROM docker.io/my/image:v1.2.3-alpine@sha256:abcdefg
		FROM foo:1.2.3
		RUN echo test
		FROM bar:4.5.6
	''', '1.2.3'),
])

def test_sanitize(input, expected):
	assert tagify.parse_version(input) == expected

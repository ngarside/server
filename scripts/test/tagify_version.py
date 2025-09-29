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
		FROM docker.io/my/image:v12.34.56-alpine@sha256:abcdefg
		RUN echo test
		FROM bar:78.90.12
	''', '12.34.56'),

	# Short reference.
	('''
		# Header
		FROM foo:1
		RUN echo test
		FROM bar:4.5.6
	''', '1'),

	# Long reference.
	('''
		# Header
		FROM foo:1.2.3.4.5
		RUN echo test
		FROM bar:4.5.6
	''', '1.2.3.4.5'),

	# Rolling reference.
	('''
		# Header
		FROM docker.io/my/image:latest@sha256:abcdefg
		RUN echo test
		FROM bar:4.5.6
	''', '0.0.0'),
])

def test_sanitize(input, expected):
	assert tagify.version(input) == expected

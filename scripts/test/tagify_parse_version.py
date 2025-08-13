#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import pytest, tagify

@pytest.mark.parametrize('input, expected', [
	('FROM hi:1.2.3', '1.2.3'),
])

def test_sanitize(input, expected):
	assert tagify.parse_version(input) == expected

#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import pytest, testify

@pytest.mark.parametrize('input, expected', [
	('service/src/service.dockerfile', 'service/test/service.py'), # Shared name.
	('service/src/image.dockerfile', 'service/test/image.py'), # Different names.
])

def test_sanitize(input, expected):
	assert testify.assemble(input) == expected

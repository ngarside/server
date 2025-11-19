#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import pytest, specifier_to_dockerfile

@pytest.mark.parametrize('input, expected', [
	('service', 'service/src/service.dockerfile'), # Shared name.
	('service/image', 'service/src/image.dockerfile'), # Different names.
])

def test_sanitize(input, expected):
	assert specifier_to_dockerfile.specifier_to_dockerfile(input) == expected

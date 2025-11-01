#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import pytest, namify

@pytest.mark.parametrize('input, expected', [
	('service/src/service.dockerfile', 'ghcr.io/ngarside/service'), # Shared name.
	('service/src/image.dockerfile', 'ghcr.io/ngarside/service-image'), # Different names.
])

def test_sanitize(input, expected):
	assert namify.assemble(input) == expected

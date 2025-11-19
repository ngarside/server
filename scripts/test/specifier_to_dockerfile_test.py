#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import specifier_to_dockerfile

def test_with_image():
	actual = specifier_to_dockerfile.specifier_to_dockerfile('service/image')
	assert actual == 'service/src/image.dockerfile'

def test_without_image():
	actual = specifier_to_dockerfile.specifier_to_dockerfile('service')
	assert actual == 'service/src/service.dockerfile'

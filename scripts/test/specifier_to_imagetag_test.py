#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import specifier_to_imagetag

def test_with_image():
	actual = specifier_to_imagetag.specifier_to_imagetag('service/image')
	assert actual == 'ghcr.io/ngarside/service-image'

def test_without_image():
	actual = specifier_to_imagetag.specifier_to_imagetag('service')
	assert actual == 'ghcr.io/ngarside/service'

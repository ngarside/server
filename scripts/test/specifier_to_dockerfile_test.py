#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pathlib, pytest, sys

sys.path.append(str(pathlib.Path(__file__).parent.parent / 'src'))
import specifier_to_dockerfile

def test_empty():
	with pytest.raises(ValueError):
		specifier_to_dockerfile.specifier_to_dockerfile('')

def test_extra_part():
	with pytest.raises(ValueError):
		specifier_to_dockerfile.specifier_to_dockerfile('service/image/component')

def test_with_image():
	actual = specifier_to_dockerfile.specifier_to_dockerfile('service/image')
	assert actual == 'service/src/image.dockerfile'

def test_without_image():
	actual = specifier_to_dockerfile.specifier_to_dockerfile('service')
	assert actual == 'service/src/service.dockerfile'

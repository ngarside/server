#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, pytest, sys, tempfile
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import specifier_to_exists

def test_empty():
	with pytest.raises(ValueError):
		specifier_to_exists.specifier_to_exists('')

def test_exists_with_image():
	with tempfile.TemporaryDirectory() as root:
		os.chdir(root)
		dockerfile = Path(root) / 'service' / 'src' / 'image.dockerfile'
		dockerfile.parent.mkdir(parents=True)
		dockerfile.touch()
		actual = specifier_to_exists.specifier_to_exists('service/image')
		assert actual == 0

def test_exists_without_image():
	with tempfile.TemporaryDirectory() as root:
		os.chdir(root)
		dockerfile = Path(root) / 'service' / 'src' / 'service.dockerfile'
		dockerfile.parent.mkdir(parents=True)
		dockerfile.touch()
		actual = specifier_to_exists.specifier_to_exists('service')
		assert actual == 0

def test_extra_part():
	with pytest.raises(ValueError):
		specifier_to_exists.specifier_to_exists('service/image/component')

def test_not_exists_with_image():
	actual = specifier_to_exists.specifier_to_exists('service/image')
	assert actual == 1

def test_not_exists_without_image():
	actual = specifier_to_exists.specifier_to_exists('service')
	assert actual == 1

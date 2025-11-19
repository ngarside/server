#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pytest, sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import specifier_to_testfile

def test_empty():
	with pytest.raises(ValueError):
		specifier_to_testfile.specifier_to_testfile('')

def test_extra_part():
	with pytest.raises(ValueError):
		specifier_to_testfile.specifier_to_testfile('service/image/component')

def test_with_image():
	actual = specifier_to_testfile.specifier_to_testfile('service/image')
	assert actual == 'service/test/image.py'

def test_without_image():
	actual = specifier_to_testfile.specifier_to_testfile('service')
	assert actual == 'service/test/service.py'

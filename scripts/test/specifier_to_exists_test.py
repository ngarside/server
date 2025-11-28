#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import pytest, sys, tempfile
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent / 'src'))
import specifier_to_exists

def test_empty():
	with pytest.raises(ValueError):
		specifier_to_exists.specifier_to_exists('')

def test_exists_with_image():
	actual = specifier_to_exists.specifier_to_exists('gitea/server')
	assert actual == 0

def test_exists_without_image():
	actual = specifier_to_exists.specifier_to_exists('memos')
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

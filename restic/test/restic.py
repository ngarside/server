#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, subprocess

image = f'ghcr.io/ngarside/restic:{os.getenv('TAG') or 'latest'}'

def test_version():
	result = subprocess.run(['podman', 'run', image, 'version'], capture_output=True, text=True)
	assert result.stdout.startswith('restic')

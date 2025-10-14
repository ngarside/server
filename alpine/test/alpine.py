#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import os, subprocess

image = f'ghcr.io/ngarside/alpine:{os.getenv('TAG') or 'latest'}'

def test_whoami():
	result = subprocess.run(['podman', 'run', image, 'whoami'], capture_output=True, text=True)
	assert result.stdout == 'root\n'

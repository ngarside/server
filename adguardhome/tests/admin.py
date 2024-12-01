#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import random, requests, subprocess

def test_home():
	try:
		port = random.randrange(1000, 64000)
		subprocess.run([
			'docker', 'run', '--detach', '--name', 'adguardhome',
			'--publish', f'{port}:80', 'ghcr.io/ngarside/adguardhome'
		])
		res = requests.get(f'http://localhost:{port}')
		assert res.status_code == 200
	finally:
		subprocess.run(['docker', 'rm', '--force', 'adguardhome'])

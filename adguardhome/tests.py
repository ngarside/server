#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import random, requests, string, subprocess

def admin_home():
	try:
		name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
		print()
		port = random.randrange(1000, 64000)
		subprocess.run([
			'docker', 'run', '--detach', '--name', name,
			'--publish', f'{port}:80', 'ghcr.io/ngarside/adguardhome'
		])
		res = requests.get(f'http://localhost:{port}')
		assert res.status_code == 200
	finally:
		subprocess.run(['docker', 'rm', '--force', name])

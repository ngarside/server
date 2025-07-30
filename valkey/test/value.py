#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import os, pytest, random, string, subprocess, time, valkey

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', name, '--publish',
		f'{port}:6379', '--pull', 'never', f'ghcr.io/ngarside/valkey:{tag}',
	])
	time.sleep(0.1)
	yield
	subprocess.run(['podman', 'rm', '--force', name])

def test_bytes():
	session = valkey.Valkey(port=port)
	session.set('foo', 'bar')
	actual = session.get('foo')
	assert actual == b'bar'

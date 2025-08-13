#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import contextlib, os, psycopg, pytest, random, string, subprocess, time

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global session
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1025, 65536)
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--env', 'POSTGRES_DB=postgres', '--env',
		'POSTGRES_PASSWORD=postgres', '--env', 'POSTGRES_USER=postgres',
		'--name', name, '--publish', f'{port}:5432', '--pull',
		'never', f'ghcr.io/ngarside/postgres:{tag}',
	])
	for _ in range(100):
		try:
			session = psycopg.connect(
				host='localhost',
				port=port,
				user='postgres',
				password='postgres',
			)
		except:
			time.sleep(0.1)
	yield
	subprocess.run(['podman', 'rm', '--force', name])

def test_select():
	with contextlib.closing(session) as conn:
		with conn.cursor() as cur:
			cur.execute('select 1')
			assert cur.fetchone()[0] == 1

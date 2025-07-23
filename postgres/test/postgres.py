#!/usr/bin/env python

# This is free and unencumbered software released into the public domain.

import os, pytest, random, requests, string, subprocess, time
import psycopg
from contextlib import closing

@pytest.fixture(autouse=True, scope='session')
def fixture():
	global port
	name = ''.join([random.choice(string.ascii_letters) for _ in range(6)])
	port = random.randrange(1000, 64000)
	dir = os.path.dirname(os.path.realpath(__file__))
	subprocess.run([
		'docker', 'run', '--env', 'POSTGRES_USER=postgres', '--env', 'POSTGRES_PASSWORD=your_password', '--env', 'POSTGRES_DB=mydb', '--detach', '--name', name, '--publish', f'{port}:5432',
		'--pull', 'never', '--volume', f'{dir}:/etc/caddy:ro',
		'ghcr.io/ngarside/postgres'
	])
	time.sleep(3)
	global session
	session = psycopg.connect(
		host="localhost",
		port=port,
		user="postgres",
		password="your_password"
	)
	yield
	# subprocess.run(['docker', 'rm', '--force', name])

def test_respond():
	with closing(session) as conn:
		with conn.cursor() as cur:
			cur.execute("SELECT 1;")
			assert cur.fetchone()[0] == 1

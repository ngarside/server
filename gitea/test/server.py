#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import base64, os, pytest, random, tempfile, requests, subprocess, time

secrets = tempfile.TemporaryDirectory()
name, port = random.sample(range(1025, 65536), 2)
secret = base64.urlsafe_b64encode(os.urandom(32)).rstrip(b'=')

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	with open(os.path.join(secrets.name, 'gitea_oidc_secret'), 'w') as oidc:
		oidc.write('')
	with open(os.path.join(secrets.name, 'machine_domain_root'), 'w') as domain:
		domain.write('localhost')
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port}:80', '--pull', 'never', '--read-only', '--tmpfs', '/etc',
		'--volume', f'{secrets.name}:/run/secrets', f'ghcr.io/ngarside/gitea-server:{tag}',
	])
	time.sleep(10)
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_root():
	response = session.get(f'http://localhost:{port}')
	assert response.status_code == 200

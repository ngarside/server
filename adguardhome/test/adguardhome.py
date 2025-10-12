#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import dns.resolver, os, pytest, random, requests, subprocess, tempfile

etc, opt = [tempfile.TemporaryDirectory() for _ in range(2)]
name, port_admin, port_dns = random.sample(range(1025, 65536), 3)

session = requests.Session()
session.mount('http://', requests.adapters.HTTPAdapter(max_retries=10))

@pytest.fixture(autouse=True, scope='session')
def fixture():
	open(os.path.join(etc.name, 'config.yml'), 'w').close()
	tag = os.getenv('TAG') or 'latest'
	subprocess.run([
		'podman', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port_admin}:80', '--publish', f'{port_dns}:53', '--publish',
		f'{port_dns}:53/udp', '--pull', 'never', '--read-only', '--volume',
		f'{etc.name}:/etc/adguardhome', '--volume',
		f'{opt.name}:/opt/adguardhome', f'ghcr.io/ngarside/adguardhome:{tag}',
	])
	yield
	subprocess.run(['podman', 'rm', '--force', f'{name}'])

def test_admin_home():
	response = session.get(f'http://localhost:{port_admin}', timeout=10)
	assert response.status_code == 200

def test_healthcheck():
	status = subprocess.run(['podman', 'healthcheck', 'run', f'{name}'])
	assert status.returncode == 0

def test_dns_tcp():
	request = dns.message.make_query('example.com', dns.rdatatype.ANY)
	dns.query.tcp(request, '127.0.0.1', 10, port_dns)

def test_dns_udp():
	request = dns.message.make_query('example.com', dns.rdatatype.ANY)
	dns.query.udp(request, '127.0.0.1', 10, port_dns)

#!/usr/bin/env python
# This is free and unencumbered software released into the public domain.

import dns.resolver, os, pytest, random, requests, subprocess, tempfile

etc = tempfile.TemporaryDirectory()
name, port_admin, port_dns = random.sample(range(1000, 64000), 3)

@pytest.fixture(autouse=True, scope='session')
def fixture():
	open(os.path.join(etc.name, 'config.yml'), 'w').close()
	subprocess.run([
		'docker', 'run', '--detach', '--name', f'{name}', '--publish',
		f'{port_admin}:80', '--publish', f'{port_dns}:53',
		'--publish', f'{port_dns}:53/udp', '--volume',
		f'{etc.name}:/etc/adguardhome', 'ghcr.io/ngarside/adguardhome',
	])
	yield
	subprocess.run(['docker', 'rm', '--force', f'{name}'])

def test_admin_home():
	response = requests.get(f'http://localhost:{port_admin}', timeout=10)
	assert response.status_code == 200

def test_dns_tcp():
	request = dns.message.make_query('example.com', dns.rdatatype.ANY)
	dns.query.tcp(request, '127.0.0.1', 10, port_dns)

def test_dns_udp():
	request = dns.message.make_query('example.com', dns.rdatatype.ANY)
	dns.query.udp(request, '127.0.0.1', 10, port_dns)

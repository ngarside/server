# This is free and unencumbered software released into the public domain.

# Connects to the VM via SSH.

$IP = sudo powershell "(Get-VM -Name Server).NetworkAdapters.IPAddresses[0]"

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@$IP 2> $null

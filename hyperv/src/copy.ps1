# This is free and unencumbered software released into the public domain.

# Copies files to/from the VM via SCP.

$IP = sudo powershell "(Get-VM -Name Server).NetworkAdapters.IPAddresses[0]"

scp 
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null core@$IP 2> $null

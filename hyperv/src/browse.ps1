# This is free and unencumbered software released into the public domain.

# Opens the VM's homepage in the default browser.

param (
	[Parameter(Mandatory=$true)][string]$name
)

$IP = sudo powershell "(Get-VM -Name $name).NetworkAdapters.IPAddresses[0]"

Start-Process "http://$IP"

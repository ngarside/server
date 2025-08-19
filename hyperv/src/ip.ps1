# This is free and unencumbered software released into the public domain.

# Prints the IP address of the VM.

param (
	[Parameter(Mandatory=$true)][string]$name
)

sudo powershell "(Get-VM -Name $name).NetworkAdapters.IPAddresses[0]"

# This is free and unencumbered software released into the public domain.

# Deletes the VM if it exists.

param (
	[Parameter(Mandatory=$true)][string]$name
)

sudo powershell @"
	Remove-VM -Name $name -Force

	Remove-Item -Force -Path F:\$name -Recurse
"@

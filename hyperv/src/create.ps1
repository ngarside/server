# This is free and unencumbered software released into the public domain.

# Creates a new VM. For this to work the VM must not already exist.

param (
	[Parameter(Mandatory=$true)][string]$name
)

sudo powershell @"
	New-VM -Generation 2 -MemoryStartupBytes 8GB -Name $name -Path F: -Switch "Default Switch"

	New-VHD -Dynamic -Path "F:\$name\Virtual Hard Disks\System.vhdx" -SizeBytes 250GB

	New-VHD -Dynamic -Path "F:\$name\Virtual Hard Disks\Data.vhdx" -SizeBytes 1TB

	`$DiskDrive = Add-VMDvdDrive -VMName $name -PassThru

	`$SystemDrive = Add-VMHardDiskDrive -VMName $name -PassThru -Path "F:\$name\Virtual Hard Disks\System.vhdx"

	Add-VMHardDiskDrive -VMName $name -Path "F:\$name\Virtual Hard Disks\Data.vhdx"

	Set-VMProcessor -VMName $name -Count 32

	Set-VMFirmware -VMName $name -SecureBootTemplate "MicrosoftUEFICertificateAuthority"

	Set-VM -VMName $name -AutomaticStartAction Nothing

	Set-VM -VMName $name -AutomaticStopAction TurnOff

	Set-VMFirmware $name -BootOrder `$SystemDrive,`$DiskDrive
"@

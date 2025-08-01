# This is free and unencumbered software released into the public domain.

# Creates a new VM. For this to work the VM must not already exist.

sudo powershell @"
	New-VMSwitch -Name "Server Switch" -NetAdapterName Ethernet

	New-VM -Generation 2 -MemoryStartupBytes 8GB -Name Server -Path F: -Switch "Server Switch"

	New-VHD -Dynamic -Path "F:\Server\Virtual Hard Disks\System.vhdx" -SizeBytes 250GB

	New-VHD -Dynamic -Path "F:\Server\Virtual Hard Disks\Data.vhdx" -SizeBytes 1TB

	$DiskDrive = Add-VMDvdDrive -VMName Server -PassThru

	$SystemDrive = Add-VMHardDiskDrive -VMName Server -PassThru -Path "F:\Server\Virtual Hard Disks\System.vhdx"

	Add-VMHardDiskDrive -VMName Server -Path "F:\Server\Virtual Hard Disks\Data.vhdx"

	Set-VMProcessor -VMName Server -Count 32

	Set-VMFirmware -VMName Server -SecureBootTemplate "MicrosoftUEFICertificateAuthority"

	Set-VM -VMName Server -AutomaticStartAction Nothing

	Set-VM -VMName Server -AutomaticStopAction TurnOff

	Set-VMFirmware Server -BootOrder $SystemDrive,$DiskDrive
"@

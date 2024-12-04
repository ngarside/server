# This is free and unencumbered software released into the public domain.

New-VM -Generation 2 -MemoryStartupBytes 8GB -Name Server -Path F: -Switch "Default Switch"

New-VHD -Dynamic -Path "F:\Server\Virtual Hard Disks\System.vhdx" -SizeBytes 250GB

New-VHD -Dynamic -Path "F:\Server\Virtual Hard Disks\Data.vhdx" -SizeBytes 1TB

Add-VMDvdDrive -VMName Server

Add-VMHardDiskDrive -VMName Server -Path "F:\Server\Virtual Hard Disks\System.vhdx"

Add-VMHardDiskDrive -VMName Server -Path "F:\Server\Virtual Hard Disks\Data.vhdx"

Set-VMProcessor -VMName Server -Count 32

Set-VMFirmware -VMName Server -EnableSecureBoot Off

# Set-VMFirmware -VMName Server -SecureBootTemplate "MicrosoftUEFICertificateAuthority"

Set-VM -VMName Server -AutomaticStartAction Nothing

Set-VM -VMName Server -AutomaticStopAction TurnOff
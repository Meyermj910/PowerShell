<#
.Synopsis
   Retrieves logical disk information from one or more computers.
.DESCRIPTION
   Get-DiskInventory uses WMI to retrieve the win32_LogicalDisk instances from one or more computers. It displays each disk's drive letter, free space, total size, and percentage of free space.
.PARAMETER computername
   The computer name, or names to query. Default:LocalHost.
.PARAMETER drivetype
   Specifies the drive type to query. See Win32_LogicalDisk documentation for values. 3 is a fixed disk and is the default.
.EXAMPLE
   .\Get-DiskInventory.ps1 -computername SSWSW01 -Drivetype 2
.EXAMPLE
   .\Get-DiskInventory.ps1 SSDC01 -DriveType3
.EXAMPLE
   .\Get-DiskInventory.ps1 SSWSW01
#>


param (
$computername = 'localhost',
$drivetype = 3
)

Get-WmiObject -class win32_logicaldisk `
 -ComputerName $computername -filter "drivetype=$drivetype" | sort -Property deviceid | ft -Property deviceid,
 @{n='FreeSpace(MB)';e={$_.FreeSpace / 1MB -as [int]}},
 @{n='Size(GB)';e={$_.Size / 1GB -as [int]}},
 @{n='%Free';e={$_.FreeSpace / $_.Size * 100 -as [int]}}

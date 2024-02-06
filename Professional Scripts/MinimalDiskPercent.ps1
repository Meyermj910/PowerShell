<#
.Synopsis
   Get drives based on percentage of Free Space.
.DESCRIPTION
   This command will get all local drives that have less than the specified percentage of free space available.
.PARAMETER ComputerName
   The computer name, or names to query. 'Local Host' is the Default computer name selected.
.PARAMETER DriveType
   Specifies the drive type to query. See Win32_LogicalDisk documentation for values. 3 is a fixed disk and is the Default.
.PARAMETER MinimumPercentFree
   The minimum percent free diskspace. This is the threshold. The default value is 10. Enter a number between 1 and 100. Use the Param -minimum to set the number.
.EXAMPLE
   .\MinimalDiskPerecent.ps1 -minimum 20

   Find all disks on the local computer with less than 20% free space.
.EXAMPLE
   .\MinimalDiskPerecent.ps1 -comp SSDC01 -minimum 45

   Find all local disks on computer name SSDC01 with less than 45% free space.
#>


param (
$ComputerName = 'localhost',
$DriveType = 3,
$MinimumPercentFree = 10
)

#Convert Minimal Percent Free
$MinPercent = $MinimumPercentFree/100

Get-WmiObject win32_logicaldisk -computername $ComputerName -filter "drivetype=$DriveType" |
 where {($_.freespace / $_.size) -lt $MinPercent} | select -Property deviceid,
 @{n='%Free';e={$_.FreeSpace / $_.Size * 100 -as [int]}},
 @{n='Size(GB)';e={$_.Size / 1GB -as [int]}}
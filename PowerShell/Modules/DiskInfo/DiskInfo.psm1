<#
.Synopsis
This is the Short Description.
.Description
This is the Long Description.
.Parameter ComputerName
This is where you type in the name of the computer you want direct the command to.
.Parameter Bogus
This is here for absolutely nothing more than a test.
.Example
Test.ps1 -Computername [Name of Computer] -bogus [This is here for absolutely nothing and just a test]
#>
function Get-DiskInfo{
[Cmdletbinding()]
param(
    [Parameter(Mandatory=$True)]
    [string[]]$ComputerName,
    $bogus
)

Get-WmiObject -ComputerName $ComputerName -Class win32_logicaldisk -filter "DeviceID='c:'" | select @{n='FreeSpaceGB';e={$_.freespace/1gb -as [int]}}
}
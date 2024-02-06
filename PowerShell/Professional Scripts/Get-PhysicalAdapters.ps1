<#
.Synopsis
   Get physical Network Adapters.
.DESCRIPTION
   Display all physical Network Adapters from the Win32_NetworkAdapter class.
.EXAMPLE
   .\Get-PhysicalAdapters.ps1 -ComputerName SSDC01
#>

[CmdletBinding()]
param(
[Parameter(Mandatory=$True,HelpMessage="Enter a ComputerName to query")]
[Alias('HostName')]
[String]$ComputerName

)

Write-Verbose "Getting physical network adapters from $ComputerName."
Get-CimInstance win32_networkadapter -ComputerName $ComputerName | 
Where-Object {$_.PhysicalAdapter} | 
Select-Object MACAddress,AdapterType,DeviceID,Name,Speed
Write-Verbose "Script Finished"

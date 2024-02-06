<#
.Synopsis
   This is a script to gather information for Help Desk calls.
.DESCRIPTION
   This is a basic script designed to gather user and computer information for HelpDesk calls.
   Information gathered includes:
   DNS Name & IP Address
   DNS Server
   Name of Operating System
   Amount of Memory in Target Computer
   Amount of Free Space on Disk
   Last Reboot of System
.EXAMPLE
   Get-Support
   PS C:\scripts\M5 .\Get-HelpDeskSupportData.ps1

   cmdlet get-helpdesksupportdata.ps1 at command pipeline position 1
   Supply values for the following parameters:
   ComputerName: $ComputerName
   Username: mbender

   In this example, the script is simply run and the parameters are input as they are mandatory.
.EXAMPLE
   Get-SupportInfo.ps1 -ComputerName Client1 -Username usrmvb

   This example has mandatory parameters input when calling script.

.EXAMPLE
    Get-SupportInfo.ps1 -ComputerName Client1 -Username usrmvb | out-file c:\userinfo.txt

    This example sends the output of the script to a text file.
#>

#Get-HelpDeskSupport.ps1
#Josh Meyer
#Created: May 28, 2022
#Updated: N/A
#Updates: N/A
#References: N/A

##Parameters for ComputerName & UserName
Param (
    [Parameter(Mandatory=$True)]
    [string]$ComputerName
)

#Variables
$Credential = Get-Credential
$CimSession = New-CimSession $ComputerName -Credential $Credential
$Analyst = $Credential.UserName

#Commands

#OS Description
$OS = (Get-CimInstance Win32_OperatingSystem -ComputerName $ComputerName).Caption

#Disk FreeSpace on OS Drive
$Drive = Get-CimInstance -Class Win32_LogicalDisk | Where-Object DeviceID -EQ 'C:'
$Freespace = (($Drive.FreeSpace)/1GB)

#Amount of System Memory
$MemoryInGB = ((((Get-CimInstance Win32_PhysicalMemory -ComputerName $ComputerName).Capacity | Measure-Object -Sum).Sum)/1GB)

#Last Reboot of System
$LastReboot = (Get-CimInstance -Class Win32_OperatingSystem -ComputerName $ComputerName).LastBootUpTime

#IP Address & DNS Name
$DNS = Resolve-DnsName -Name $ComputerName | Where-Object Type -EQ "A"
$DNSName = $DNS.Name
$DNSIP = $DNS.IP
$IPInfo = Get-CimInstance Win32_NetworkAdapterConfiguration

#DNS Server of Target
$DNSServer = (Get-DnsClientServerAddress -CimSession $CimSession -InterfaceAlias "ethernet" -AddressFamily IPv4).ServerAddresses

#Write Output to Screen
#Clear-Host
Write-Output "HelpDesk Support Info for $ComputerName"
Write-Output "......................................."
Write-Output "Support Analyst: $Analyst";""
Write-Output "ComputerName: $ComputerName":""
Write-Output "Last System Reboot of $ComputerName : $LastReboot ";""
Write-Output "DNS Name of $ComputerName : $DNSName":""
Write-Output "IP Address of $DNSName : $DNSIP";""
Write-Output "DNS Server(s) for $ComputerName : $DNSServer";""
Write-Output "Total System Ram in $ComputerName : $MemoryInGB GB";""
Write-Output "FreeSpace on C: $Freespace GB";""
Write-Output "Version of Operating System: $OS"
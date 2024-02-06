<#
.Synopsis
   This will set a security group and remove roaming profile path.
.DESCRIPTION
   This will set a $User to the Security $Group listed. This will also remove any roaming profile path for the user.
.EXAMPLE
   .\SGroup-RProfile.ps1 -ComputerName SSDC01
#>


function Configure-OneDrive{
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$User,

$Group = 'Prevent Docs Redirection Policy'

)

Write-Verbose "Adding user to the Security Group $Group"
#Add User To "Folder Redirection Policy"
    Add-ADGroupMember -Identity $Group -Members $User

Write-Verbose "Removing $User Roaming Profile Path"
#Remove users Roaming Profile Path
    Get-ADUser -Identity "$User" -Properties ProfilePath | Set-ADUser -Clear ProfilePath

Write-Verbose "Added user to the Security Group $Group & Removing their Roaming Profile Path is complete."

}
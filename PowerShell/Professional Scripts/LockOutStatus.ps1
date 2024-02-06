<#
.Synopsis
This will display the LockOut Status of the user(s) targeted.
.Description
This Cmdlet will display the users DisplayName, Title, Email Address, If they're Locked Out, Password Expired, Password Last Set, Password Expiry Date.
.Parameter UserName
Type in the name of the user you wish to target. Current User logged in, is the Default.
.Example
Get-LockOutStatus jmeyer
#>

function Get-LockOutStatus{
 [Cmdletbinding()]
param(
$Username = "$env:UserName"
)

$LockedOut = (Get-ADUser -Identity $Username -Properties *).LockedOut

Get-ADUser -Identity $Username -Properties * | Select DisplayName,Title,EmailAddress,LockedOut,
PasswordExpired,PasswordLastSet,@{N="PasswordExpiryDate";E={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}}}

if ($LockedOut -eq $true)
{
    Unlock-ADAccount -Identity $Username -Confirm
}
}

Pause
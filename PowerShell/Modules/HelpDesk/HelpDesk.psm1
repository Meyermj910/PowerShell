  <#
  .Synopsis
  This is a Module to assist the Help Desk Team with basic queries and unlocking AD Accounts.
  .Description
  This Module helps the Desk gather standard information such as user Lock Out Status, Security groups on their AD Object and the ability to Unlock AD accounts.

  Commands
  Get-(domain)LockOutStatus - Provides LockOutStatus info for a user.
  Get-(domain)SecurityGroup - Provides the users Security Groups that is applied to their AD Object.
  Unlock-(domain)User - Grants the ability to unlock a user account.

  .Parameter UserName
  Type in the name of the user you wish to target. Current User logged in, is the Default.
  .Example
  Get-LockOutStatus jmeyer
  #>

########################################################Client2########################################################
########################################################Client2########################################################
########################################################Client2########################################################

###LOCK OUT STATUS###

function Get-Client2LockOutStatus{
<#
        .SYNOPSIS
            Provides a general inquiry on a Client2 users account status.

        .DESCRIPTION
            Get-Client2LockOutStatus will provide a LockOut Status report on a users account regarding the last time a password was set, if its expired, what office they're from, email address, display name and Title.

        .PARAMETER Username
            The Username parameter is used to target the user you want to check on.

        .EXAMPLE
            Get-Client2LockOutStatus ajmeyer
            ###Results will return below:
            DisplayName     : Joshua Meyer Admin
            Title           : Help Desk Technician III
            Office          :
            EmailAddress    :
            LockedOut       : False
            PasswordExpired : False
            PasswordLastSet : 7/22/2022 12:54:29 PM

        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client2Server = 'domain.com'
)

Get-ADUser -Server $Client2Server -Identity $Username -Properties * -Credential $Client2Creds | Select DisplayName,Title,Office,EmailAddress,LockedOut,
PasswordExpired,PasswordLastSet,AccountExpirationDate

}

###USER SECURITY GROUPS###

function Get-Client2UserSecurityGroup{
<#
        .SYNOPSIS
            Provides an inquiry on a users Security Groups.

        .DESCRIPTION
            Get-Client2UserSecurityGroup will provide a list of security groups the user has access to.

        .PARAMETER Username
            The Username parameter is used to target the user you want to check on.

        .EXAMPLE
            Get-Client2UserSecurityGroup ajmeyer
            ###Results will return below:

        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client2Server = 'domain.com'
)

$Name = (Get-ADUser -Identity $Username -Server $Client2Server -Credential $Client2Creds).Name

Get-ADPrincipalGroupMembership -Identity $Username -Server $Client2Server -Credential $Client2Creds | Select-Object @{N="$Name Security Groups";E={$_.Name }} | Sort-Object "$Name Security Groups"

}

###UNLOCK USERS AD ACCOUNT###

function Unlock-Client2User{
<#
        .SYNOPSIS
            Unlocks a Client2 users account.

        .DESCRIPTION
            Unlock-Client2User will unlock a users AD account.

        .PARAMETER Username
            The Username parameter is used to target the user you want to unlock.

        .EXAMPLE
            Unlock-Client2User ajmeyer

        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client2Server = 'domain.com'
)

Unlock-ADAccount -Server $Client2Server -Identity $Username -Credential $Client2Creds

}

###RESET Client2 AD PASSWORD###

function Reset-Client2Password{
<#
        .SYNOPSIS
            Reset a Client2 users password.

        .DESCRIPTION
            Reset-Client2Password will target a users object to reset and then prompt you to enter a new password to set it as.

        .PARAMETER Username
            The Username parameter is used to target the user you want to reset.

        .EXAMPLE
            Reset-Client2Password ajmeyer
            ###Results Will Return:
            cmdlet Reset-Client2Password at command pipeline position 1
            Supply values for the following parameters:
            (Type !? for Help.)
            Password: (Enter the new password here) / Type Ctrl + C to cancel the request.
        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
 param(
 [Parameter(Mandatory=$True)]
 $Username,
 $Client2Server = 'Client2domainserver.com',
 [Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Be Forwarded To')]
 $Password
)


 Set-ADAccountPassword -Server $Client2Server -Identity $Username -Credential $Client2Creds -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)

 }

###SEND FILE###
function Send-Client2File{
<#
        .SYNOPSIS
            Transfer a file to a Client2 users desktop.

        .DESCRIPTION
            Transfer-Client2File will target a users computer name + path and transfer whatever file you opt in to transfer.

        .PARAMETER ComputerName
            The ComputerName parameter is used to target the computer you want to transfer the file to.

        .PARAMETER Path
            Specify the path of the file or folder you want to transfer.

        .PARAMETER Destination
            Specify the path of where you want to transfer the file or folder to.

        .EXAMPLE
            Send-Client2File -Path "C:\Users\joshua.meyer\Downloads\test.txt" -Username joshua.meyer -ComputerName TEST12345676
            ###I am initiating a transfer from the Downloads folder of my computer to the Desktop location of my computer. The ComputerName is for you to target the users machine name you want to transfer to.

        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Path = "Read-Host Please Enter the File Path of the file you want to transfer",
[Parameter(Mandatory=$True)]
$ComputerName,
$Username
)

$RemoteSession = (New-PSSession -ComputerName $ComputerName -Credential $Client2Creds)

Copy-Item -Path $Path -Recurse -Destination "C:\Users\$Username\Downloads" -ToSession $RemoteSession

}

###RETRIEVE FILE###
function Retrieve-Client2File{
<#
        .SYNOPSIS
            Retrieve a file to a Client2 users desktop.

        .DESCRIPTION
            Retrieve-Client2File will target a users computer name + path and transfer whatever file you opt in to transfer.

        .PARAMETER ComputerName
            The ComputerName parameter is used to target the computer you want to transfer the file to.

        .PARAMETER Path
            Specify the path of the file or folder you want to transfer.

        .PARAMETER Destination
            Specify the path of where you want to transfer the file or folder to.

        .EXAMPLE
            Retrieve-Client2File -Path "C:\Users\joshua.meyer\Downloads\test.txt" -Username joshua.meyer -ComputerName TEST12345676
            ###I am initiating a transfer from the Downloads folder of my computer to the Desktop location of my computer. The ComputerName is for you to target the users machine name you want to transfer to.

        .NOTES
            This will currently work only on Client2 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Path = "Read-Host Please Enter the File Path of the file you want to transfer",
[Parameter(Mandatory=$True)]
$ComputerName
)

$RemoteSession = (New-PSSession -ComputerName $ComputerName -Credential $Client2Creds)

Copy-Item -Path $Path -Recurse -Destination "C:\Users\joshua.meyer\Downloads" -FromSession $RemoteSession

}

###Update User's AD Manager###
function Update-Client2Manager{
<#
        .SYNOPSIS
            Update a users manager on their AD Object.

        .DESCRIPTION
            Update a users manager on their AD Object in the Organizational tab only, this does not update their Attributes nor their signature block.

        .PARAMETER UserName
            The Username parameter is used to target the user you want to update.

        .PARAMETER Manager
            The Manager parameter is the person you want to make the manager of the selected User.

        .EXAMPLE
            Update-Client2Manager -Manager mmiller -Username ajuliano
            ###In this example, I am making "mmiler" the manager of "ajuliano".

        .NOTES
            1. This will currently work only on Client2 users.
            2. This only affects the Organizational tab of AD.
            3. It does not update their Attributes 11-15, which is whats needed to reflect on the Xink Signature Block.
            ExtensionAttribute11, ExtensionAttribute12, ExtensionAttribute13, ExtensionAttribute14, and ExtensionAttribute15.
            You can look at someone elses AD Object to see what their 11-15 Attributes are set to.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Manager
)

Set-ADUser -Identity $Username -Server domainclient2.com -Manager $Manager -Credential $Client2Creds

}

###File Security Groups###
function Get-Client1FileSecurityGroup{
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Path,
$Client1Server = 'domainclient1.com'
)

#Default Groups to Exclude
$ExcludePattern = @(
            'builtin\users',
            'Creator Owner',
            'builtin\administrators',
            'NT Authority\System',
            'Everyone'
            )

#Windows SID to Exclude the Pattern
$ExcludeRegExp = 'S-1-\d+-\d+-\d+\d+'


Get-Acl -Path $Path | Select-Object -ExpandProperty Access |
Select-Object @{name='Security Group';Expression={$_.IdentityReference}},FileSystemRights |
Where-Object 'Security Group' -NotIn $ExcludePattern | Where-Object 'Security Group' -NotMatch $ExcludeRegExp

}

###Client2 ONEDrive Config###

function Configure-Client2OneDrive{
<#
.Synopsis
   This will set a security group and remove roaming profile path.
.DESCRIPTION
   This will set a $User to the Security $Group listed. This will also remove any roaming profile path for the user.
.EXAMPLE
   .\SGroup-RProfile.ps1 -ComputerName SSDC01
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$User
)

$Client2Computer = 'domainservername'
$Group = "Prevent Docs Redirection Policy"

$Session = New-PsSession $Client2Computer -Credential $Client2Creds

Invoke-Command -Session $Session -ScriptBlock {Import-Module -Name 'ActiveDirectory'}

#Add User To "Folder Redirection Policy" Security Group
Invoke-Command -Session $Session -ScriptBlock {Add-ADGroupMember -Identity "$using:Group" -Members "$using:User" -Credential "$using:Client2Creds"}

#Remove users Roaming Profile Path
Invoke-Command -Session $Session -ScriptBlock {Get-ADUser -Identity "$using:User" -Properties ProfilePath | Set-ADUser -Clear ProfilePath -Credential "$using:Client2Creds"}

Write-Output "Added user to the Security Group $Group & Removing their Roaming Profile Path is complete."

}

###Install Xink###

function Install-Client2Xink{
    [Cmdletbinding()]
    param(
    [Parameter(Mandatory=$True)]
    $Username,
    [Parameter(Mandatory=$True)]
    $ComputerName
    )

#Establishing Settings
$Xink = "\\c:\Applications\Xink_Xink Client AD_3.2.31_x86"
$Session = (New-PSSession -ComputerName $ComputerName -Credential $Client2Creds)

Copy-Item -Path $Xink -Recurse -Destination "C:\Users\$Username\Downloads" -ToSession $Session
Write-Output "Xink has been transferred to users Download Folder"
Sleep 1

Invoke-Command -Session $Session -ScriptBlock {Start-Process "C:\Users\$Using:Username\Downloads\Xink_Xink Client AD_3.2.31_x86\install.cmd" -WindowStyle Hidden}
Write-Output "Started the Install.CMD inside of the transferred file"
Sleep 1

<#
Unable to execute remotely to the GUI/Foreground

Invoke-Command -Session $Session -ScriptBlock {Start-Process "C:\Program Files (x86)\Xink\Xink Client AD\emsclient.exe"}
Write-Output "Started the Xink Client Program, it should now be listed on the Hidden Icons"
Sleep 1
#>

Invoke-Command -Session $Session -ScriptBlock {Remove-Item -Path "C:\Users\$Using:Username\Downloads\Xink_Xink Client_3.2.23_x86" -Force -Recurse}

Write-Output "Xink install folder has been removed from Downloads Folder"

}

########################################################Client1########################################################
########################################################Client1########################################################
########################################################Client1########################################################

###LOCK OUT STATUS###

function Get-Client1LockOutStatus{
<#
        .SYNOPSIS
            Provides a general inquiry on a Client1 users account status.

        .DESCRIPTION
           Client1LockOutStatus will provide a LockOut Status report on a users account regarding the last time a password was set, if its expired, what office they're from, email address, display name and Title.

        .PARAMETER Username
            The Username parameter is used to target the user you want to check on.

        .EXAMPLE
            Get-Client1LockOutStatus ajmeyer
            ###Results will return below:
            DisplayName     : Joshua Meyer
            Title           : Support Services I
            Office          : aTS
            EmailAddress    : Joshua.Meyer@domainclient1.com
            LockedOut       : False
            PasswordExpired : False
            PasswordLastSet : 7/22/2022 12:55:16 PM

        .NOTES
            This will currently work only on Client1 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client1Server = 'domainClient1.com'
)

Get-ADUser -Server $Client1Server -Identity $Username -Properties * | Select DisplayName,Title,Office,EmailAddress,LockedOut,
PasswordExpired,PasswordLastSet,AccountExpirationDate

}

###USER SECURITY GROUPS###

function Get-Client1UserSecurityGroup{
<#
        .SYNOPSIS
            Provides an inquiry on a users Security Groups.

        .DESCRIPTION
            Get-Client1UserSecurityGroup will provide a list of security groups the user has access to.

        .PARAMETER Username
            The Username parameter is used to target the user you want to check on.

        .EXAMPLE
            Get-Client1UserSecurityGroup ajmeyer
            ###Results will return below:
            LAPS Computer Password Readers
            SCCM.Console.Read-only Analyst Collection Modification
            Active Directory Bit Locker Administrators
            APP.Igor Pavlov_7-Zip
            APP.Cisco_AnyConnect Secure Mobility Client
            Email Administrators
            Service Desk
            Acceptable Use Policy Agreements Folder Full Access
            Local Computer Administrator
            Active Directory Controlled OU Administrators
            Active Directory Administrators

        .NOTES
            This will currently work only on Client1 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client1Server = 'domainClient1.com'
)

$Name = (Get-ADUser -Identity $Username -Server $Client1Server -Credential $Client1Creds).Name

Get-ADPrincipalGroupMembership -Identity $Username -Server $Client1Server -Credential $Client1Creds | Select-Object @{N="$Name Security Groups";E={$_.Name }} | Sort-Object "$Name Security Groups"

}

###UNLOCK AD USER###
function Unlock-Client1User{
<#
        .SYNOPSIS
            Unlocks an Client1 users account.

        .DESCRIPTION
            Unlock-Client1User will unlock a users AD account.

        .PARAMETER Username
            The Username parameter is used to target the user you want to unlock.

        .EXAMPLE
            Unlock-Client1User joshua.meyer

        .NOTES
            This will currently work only on Client1 users.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Username,
$Client1Server = 'domainClient1.com'
)

Unlock-ADAccount -Server $Client1Server -Identity $Username -Credential $Client1Creds

}

###RESET Client1 USER PASSWORD###

function Reset-Client1Password{
<#
        .SYNOPSIS
            Reset an Client1 users password.

        .DESCRIPTION
            Reset-Client1Password will target a users object to reset and then prompt you to enter a new password to set it as.

        .PARAMETER Username
            The Username parameter is used to target the user you want to reset.

        .EXAMPLE
            Reset-Client1Password joshua.meyer
            ###Results Will Return:
            Supply values for the following parameters:
            (Type !? for Help.)
            Password: (Type in new password here)
        .NOTES
            This will currently work only on Client1 users.
#>
 [Cmdletbinding()]
 param(
 [Parameter(Mandatory=$True)]
 $Username,
 $Client1Server = 'domainClient1.com',
  [Parameter(Mandatory=$True,
    HelpMessage = 'Email Address Of Person To Be Forwarded To')]
 $Password
 )

 Set-ADAccountPassword -Server $Client1Server -Identity $Username -Credential $Client1Creds -NewPassword (ConvertTo-SecureString -AsPlainText "$Password" -Force)

 }

###Client2 File Security Groups###

function Get-Client2FileSecurityGroup{
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True)]
$Path
)

#Default Groups to Exclude
$ExcludePattern = @(
            'builtin\users',
            'Creator Owner',
            'builtin\administrators',
            'NT Authority\System',
            'Everyone'
            )

#Windows SID to Exclude the Pattern
$ExcludeRegExp = 'S-1-\d+-\d+-\d+\d+'

$Client2Computer = 'domainclient2'
$Session = New-PsSession $Client2Computer -Credential $Client2Creds

Invoke-Command -Session $Session -Credential $Client2Creds -ScriptBlock {Get-Acl -Path "$using:Path" | Select-Object -ExpandProperty Access |
Select-Object @{name='Security Group';Expression={$_.IdentityReference}},FileSystemRights |
Where-Object 'Security Group' -NotIn "$using:ExcludePattern" | Where-Object 'Security Group' -NotMatch "$using:ExcludeRegExp"}

}
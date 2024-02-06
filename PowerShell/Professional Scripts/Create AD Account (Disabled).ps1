# Import AD Module
Import-Module ActiveDirectory

# Grab variables from users
$firstname = Read-Host -Prompt "Please enter the first name"
$lastname = Read-Host -Prompt "Please enter the last name"

# Settings
$OU = "OU=Standard,DC=Swiftsports,DC=local"
$domain = $env:USERDNSDOMAIN

# Setting username to first inital of first name along with last name
$i = 1
$logonname = $firstname.substring(0,$i) + $lastname

# Create the AD User
New-ADUser `
    -Name "$firstname.$lastname" `
    -GivenName $firstname `
    -Surname $lastname `
    -UserPrincipalName "$logonname" `
    -AccountPassword (ConvertTo-SecureString "Password123#@!" -AsPlainText -Force) `
    -Path $OU `
    -Enabled $true

# Check to see if AD Account already exist
DO
{
If ($(Get-ADUser -Filter {SamAccountName -eq $logonname})) {
        Write-Host "Warning: Logon name" $logonname.toUpper() "already exists!!" -ForegroundColor:Green
        $i++
        $logonname = $firstname.Substring(0,$i) + $lastname
        Write-Host
        Write-Host
        Write-Host "Changing Logon name to" $logonname.ToUpper() -ForegroundColor:Green
        Write-Host
        $taken = $true
        sleep 3
    } else {
    $taken = $false
    }
} Until ($taken -eq $false)
$logonname = $logonname.ToLower()
# Create local admin for "CLIENT"

# Settings
$group = "Administrators"
$adminname = "ADMIN_ACCOUNT_NAME
$password = "SET_TO_WHATEVER_PASSWORD_YOU_WANT"

New-LocalUser `
    -Name $adminname `
    -Password (ConvertTo-SecureString $password -AsPlainText -Force) `

# Add to Admin Group
Add-LocalGroupMember -Group "$group" -Member $adminname

# Set password to not expire
Set-LocalUser -Name $adminname -PasswordNeverExpires $true
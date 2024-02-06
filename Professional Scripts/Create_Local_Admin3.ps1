# Create local admin for Local

# Settings
$group = "Administrators"
$password = Read-Host -Prompt "Please Enter Password"
$account ="newsuperuser"

New-LocalUser `
    -Name $account `
    -Password (ConvertTo-SecureString "9aUVC0%w?" -AsPlainText -Force) `

# Add to Admin Group
Add-LocalGroupMember -Group "$group" -Member $account

# Set password to not expire
Set-LocalUser -Name $account -PasswordNeverExpires $true
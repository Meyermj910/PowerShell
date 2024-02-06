# Create local admin for MGS

# Settings
$Group = "Administrators"
$User = "Admin_Account_Name"
$Password = "Type in what you'd like the password to be"

# Will check if a user account with the name "$User exists"
# If it does > It will simply write that the account exist on screen
# If it does not > It will create the admin account and place it in the administrator group locally
if (Get-LocalUser -Name $User -ErrorAction SilentlyContinue){

Write-Host "The user account $User already exists."

}
else{

New-LocalUser `
    -Name $User `
    -Password (ConvertTo-SecureString $Password -AsPlainText -Force) `

# Add to Admin Group
Add-LocalGroupMember -Group "$Group" -Member $User

# Set password to not expire
Set-LocalUser -Name $User -PasswordNeverExpires $True
}
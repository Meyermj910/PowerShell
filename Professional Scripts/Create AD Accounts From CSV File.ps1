# Import AD Module
    Import-Module ActiveDirectory

# Create A New Password
    $securepassword = ConvertTo-SecureString "Welcome123#@!" -AsPlainText -Force

# Prompt User For CSV File Path
    $filepath = Read-Host -Prompt "Please enter the path to your CSV File"

# Import The File Into A Variable
    $users = Import-Csv $filepath

# Loop Through Each Row & Gather Information
    ForEach ($user in $users) {

        #Gather the user's info
        $fname = $user.'First Name'
        $lname = $user.'Last Name'
        $jtitle = $user.'Job Title'
        $officephone = $user.'Office Phone'
        $emailaddress = $user.'Email Address'
        $description = $user.Description
        $OUpath = $user.'Organizational Unit'

# Create new AD user for each user in CSV File
    New-ADuser `
    -Name "$fname $lname" `
    -GivenName $fname `
    -Surname $lname `
    -UserPrincipalName "$fname.$lname" `
    -Path $OUPath `
    -AccountPassword $securepassword `
    -ChangePasswordAtLogon $False `
    -OfficePhone $officephone `
    -Description $description `
    -Enabled $True `
    -EmailAddress $emailaddress

#Echo Output For Each New User
    echo "Account created for $fname $lname in $OUpath"
}
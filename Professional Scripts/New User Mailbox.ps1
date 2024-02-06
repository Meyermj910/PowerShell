###Reference ADi
###KNOWLEDGE BASE LINK

#Not complete#


#Grab Variables for user
$FirstName = Read-Host -Prompt "Please enter the users First Name"
$LastName = Read-Host -Prompt "Please enter the users Last Name"
$Name = "$FirstName $LastName"

#Settings
$State = Read-Host -Prompt "Please enter the users State (Abbreviated) OU where they will be placed"
$OU = OU_PATH/$State


# Step 1 of ADi (Check to see if Mailbox already exist (User Principal Name))
DO
{
If ($(Get-Mailbox -Filter {SamAccountName -eq $UPN})) {
        Write-Host "Warning: Logon name" $UPN.toUpper() "already exists!!" -ForegroundColor:Green
        $i++
        $UPN = $Firstname.Substring(0,$i) + $Lastname
        Write-Host
        Write-Host
        Write-Host "Changing Logon name to" $UPN.ToUpper() -ForegroundColor:Green
        Write-Host
        $taken = $true
        sleep 3
    } else {
    $taken = $false
    }
} Until ($taken -eq $false)
$UPN = $UPN.ToLower()






#Step 2-3 of ADi (Creating the Mailbox)

New-RemoteMailbox -Name $Name 
                  -FirstName $FirstName 
                  -LastName $LastName 
                  -OnPremisesOrganizationalUnit $OU 
                  -UserPrincipalName $UPN 
                  -Password $password 
                  -ResetPasswordOnNextLogon:$False


#Step 4 of ADi
Set-Mailbox $UPN -EmailAddressPolicyEnable $False

Sleep 20

#Step 5 of ADi (Uncheck the box about the "Address Policy")
Add-ADGroupMember -Identity 'Office 365 Advanced Threat Protection License','Office 365 M365 License Base' -Members $UPN

#Step 6 of ADi
$Computer = 'SYNCRONIZATION_SERVER'
$Session = New-PsSession $Computer -Credential (Get-Credential)

Invoke-Command -Session $Session -ScriptBlock {Import-Module -Name 'ADSync'}

Invoke-Command -Session $Session -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}

Exit-PSSession

#Step 7 of ADi



#Step 8 of ADi



#Step 9 of ADi

Set-CASMailbox ($UPN) -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Android/*"} -OWAEnabled $false -ActiveSyncEnabled $false -OWAforDevicesEnabled $false

Set-Mailbox ($UPN) -LitigationHoldEnabled $true
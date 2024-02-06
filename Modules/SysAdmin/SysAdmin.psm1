<#
.Synopsis
This is a Module to assist Sys Admins with basic commands regarding Exchange Online Management.
.Description
This Module contains some standard basic commands specifically for Exchange Online Management. Some commands include, ForwardEmail-Copy, which is to forward user's emails with 2 differnt options, disabling forwarding & also syncing AD & ADD immediately.

#>



###Exchange Server Admin Tools###

##############################################FORWARDING##############################################
##############################
###Forward Emails w/ a Copy###
##############################
function Forward-EmailCopy{
<#
        .SYNOPSIS
            Forward a users email with a copy.

        .DESCRIPTION
            Forward-EmailCopy was created to Forward a users mailbox to a user and keep a copy of the mail on the users mailbox.

        .PARAMETER From
            The "From" parameter is used to target the user's mailbox that you want forwarded.

        .PARAMETER To
            The "To" parameter is used to target the user that you want to forward the mailbox to.

        .EXAMPLE
            Forward-EmailCopy -From joshua.meyer@Client1.com -To john.doe@Client1.com
            This example shows that we want to forward Joshua's emails to John's emails while Joshua will retain a copy of the emails in his mailbox.

        .NOTES
            ###This will currently work in either the Client2 Environment or the Client1 Environment.
            Also the Connect-ExchangeOnline command has to be ran and connected to prior to using this command.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Be Forwarded')]
$From,
[Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Be Forwarded To')]
$To
)

Set-Mailbox -Identity "$From" -DeliverToMailboxAndForward $True -ForwardingAddress "$To"

   
}



###############################
###Forward Emails w/ no Copy###
###############################
function Forward-EmailNoCopy{
<#
        .SYNOPSIS
            Forward a users email without a copy.

        .DESCRIPTION
            Forward-EmailCopy was created to Forward a users mailbox to a user and does not keep a copy of the email.

        .PARAMETER From
            The "From" parameter is used to target the user's mailbox that you want forwarded.

        .PARAMETER To
            The "To" parameter is used to target the user that you want to forward the mailbox to.

        .EXAMPLE
            Forward-EmailCopy -From joshua.meyer@Client1.com -To john.doe@Client1.com
            ###This example shows that we want to forward Joshua's emails to John's emails while Joshua will retain a copy of the emails in his mailbox.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
            Also the Connect-ExchangeOnline command has to be ran and connected to prior to using this command.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Be Forwarded')]
$From,
[Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Be Forwarded To')]
$To
)

Set-Mailbox -Identity "$From" -DeliverToMailboxAndForward $False -ForwardingAddress "$To"

}


##############################
###Disable Email Forwarding###
##############################
function Disable-EmailForwarding{
<#
        .SYNOPSIS
            Disables/Stops forwarding a users emails/mailbox.

        .DESCRIPTION
            Disable-EmailForwarding was created to stop a users mailbox from being forwarded..

        .PARAMETER Username
            The "Username" parameter is used to target the user's mailbox that you want to disable forwarding.

        .EXAMPLE
            Disable-EmailForwarding -Username joshua.meyer@Client1.com
            ###This example shows that we are disabling email forwarding for Joshua.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
            Also the Connect-ExchangeOnline command has to be ran and connected to prior to using this command.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Email Address Of Person To Have Forwarding Disabled')]
$Username
)

Set-Mailbox -Identity "$Username" -ForwardingAddress $null

}



############################
###CHECK Email Forwarding###
############################
function Check-Forwarding{
<#
        .SYNOPSIS
            Check if Email Forwarding is enabled for a mailbox.

        .DESCRIPTION
            Check-Forwarding was created to simply check is a users Mailbox Forwarding is enabled.

        .PARAMETER Mailbox
            The "Mailbox" parameter is used to target the user's mailbox that you want to check.

        .EXAMPLE
            Check-Mailbox -Mailbox joshua.meyer@Client1.com
            ###Results will return below: (Which Indicates Forwarding is disabled).
            DeliverToMailboxAndForward : False
            ForwardingAddress          :
            ForwardingSmtpAddress      :

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
            Also the Connect-ExchangeOnline command has to be ran and connected to prior to using this command.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address for the user you want to check')]
$MailBox
)

Get-Mailbox -Identity $Mailbox | Format-List DeliverToMailboxAndForward,ForwardingAddress,ForwardingSMTPAddress

}



##############################################SYNCING##############################################
##################################
###Sync Client2 AD/ADD Immediately###
##################################
function Sync-Client2AD{
<#
        .SYNOPSIS
            Remote into syncservercompname and force a sync.

        .DESCRIPTION
            This command will remote into Client2 sync server named "syncservercompname" using proper credentials. It will Import the AD Sync module to ensure it is loaded. Then it will invoke the Sync command. After executing the Sync it will automatically exit the PS Remote Session.

        .PARAMETER Client2Creds
            The Client2Creds parameter is used to force you to login with a Client2 admin account. Specify the domain first using Client2\

        .EXAMPLE
            Sync-Client2AD
            ###Results will Return: (Which indicates it was successful.
            PSComputerName  RunspaceId                           Result
            --------------  ----------                           ------
            Client2CompName 4c2df4e4-df30-6gz5-0cbe-12a91lj9072d Success

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
 [Cmdletbinding()]
param(
$Client2Creds = (Get-Secret 'Admin Client2')
)

$Client2Computer = 'Client2syncserver'

$Session = New-PsSession $Client2Computer -Credential $Client2Creds

Invoke-Command -Session $Session -ScriptBlock {Import-Module -Name 'ADSync'}

Invoke-Command -Session $Session -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}

Exit-PSSession

}



##################################
###Sync Client1 AD/ADD Immediately###
##################################
function Sync-Client1AD{
<#
        .SYNOPSIS
            Remote into Client1SyncServer and force a sync.

        .DESCRIPTION
            This command will remote into Client1s sync server named "Client1SyncServer" using proper credentials. It will Import the AD Sync module to ensure it is loaded. Then it will invoke the Sync command. After executing the Sync it will automatically exit the PS Remote Session.

        .PARAMETER Client1Creds
            The Client2Creds parameter is used to force you to login with a Client1 admin account. Specify the domain first using Client1inc\

        .EXAMPLE
            Sync-Client1AD
            ###Results will Return: (Which indicates it was successful.
            PSComputerName  RunspaceId                           Result
            --------------  ----------                           ------
            Client1ServNam  23fgUee4-09C0-9d4H-jsd2-12a9kls2uisC Success

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
 [Cmdletbinding()]
param(
$Client1SCreds = (Get-Secret 'Admin Client1')
)

$Client1Computer = 'Client1PCName'

$Session = New-PsSession $Client1Computer -Credential $Client1Creds

Invoke-Command -Session $Session -ScriptBlock {Import-Module -Name 'ADSync'}

Invoke-Command -Session $Session -ScriptBlock {Start-ADSyncSyncCycle -PolicyType Delta}

Exit-PSSession

}



##############################################MAILBOX ACCESS##############################################
####################################
###Check Mailbox Access to a User###
####################################
function Check-MailBoxAccess{
<#
        .SYNOPSIS
            General inquiry on a users mailbox.

        .DESCRIPTION
            Check-MailBoxAccess will run a general inquiry to gather information that can be used to determine who has access to this users mailbox.

        .PARAMETER MailBox
            The MailBox parameter is used to target the users mailbox you are inquiring about.

        .EXAMPLE
            Check-MailBoxAccess johndoe@Client2.com
            ###Results will Return: (Which indicates it was successful.
            RunspaceId      : jfhj3892-98vD-08fF-8fd3-6khj34f3db
            AccessRights    : {FullAccess, ReadPermission}
            Deny            : False
            InheritanceType : All
            User            : NT AUTHORITY\SELF
            UserSid         : S-1-5-10
            Identity        : John Doe_9237Fefdfkh
            IsInherited     : False
            IsValid         : True
            ObjectState     : Unchanged

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address for the user you want to check')]
$MailBox
)

Get-MailboxPermission -Identity "$MailBox" | Format-List

}



####################################
###Grant Mailbox Access to a User###
####################################

function Grant-MailBoxAccess{
<#
        .SYNOPSIS
            This will grant a targeted users mailbox access, to a person you indicate.

        .DESCRIPTION
            Grant-MailBoxAccess will grant access to a users mailbox to an account that you choose and it will also "AutoMap" it to their Outlook for them.

        .PARAMETER MailBox
            The MailBox parameter is used to target the users mailbox that you are wanting to grant to other users.

        .PARAMETER UserToGrant
            The UserToGrant paramenter is used to specify the person that you want to grant access to said "MailBox".

        .EXAMPLE
            Grant-MailBoxAccess -Mailbox joshua.meyer@Client1.com -UsertoGrant john.doe@Client1.com
            ###This will give John Doe access to Joshua Meyers mailbox.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email Address of the users Mailbox that you want to grant to others')]
$Mailbox,
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email Address of the user you want to Grant Access')]
$UserToGrant
)

Add-MailboxPermission -Identity "$Mailbox" -User "$UserToGrant" -AccessRights FullAccess -InheritanceType All -Automapping $true 

}



#####################################
###Remove Mailbox Access to a User###
#####################################

function Remove-MailBoxAccess{
<#
        .SYNOPSIS
            This will remove users from accessing a MailBox.

        .DESCRIPTION
            Remove-MailBoxAccess will target a mailbox and remove another other user from accessing it.

        .PARAMETER MailBox
            The MailBox parameter is used to target the users mailbox that you are wanting to stop granting to other users.

        .PARAMETER UserToGrant
            The UserToRevoke paramenter is used to specify the person that you want to revoke access to said "MailBox".

        .EXAMPLE
            Remove-MailBoxAccess -Mailbox joshua.meyer@Client1.com -UsertoRevoke john.doe@Client1.com
            ###This will revoke John Doe's access to Joshua Meyers mailbox.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email Address of the Mailbox youd like to target')]
$Mailbox,
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email Address Of The Person Being Granted Access')]
$UserToRevoke
)

Remove-MailboxPermission -Identity "$Mailbox" -User "$UserToRevoke" -AccessRights FullAccess -InheritanceType All  

}

####################################
###Check Mailbox Access to a User###
####################################


function Check-MailBoxSize{
<#
        .SYNOPSIS
            This will check a users Mailbox Size.

        .DESCRIPTION
            Check-MailBoxSize targets the users mailbox & runs a query to determine the users MaxSendSize,MaxReceiveSize and recipient limits.

        .PARAMETER Email
            Specify the Email Address you want to look up to see if its in use.

        .EXAMPLE
            Check-MailBoxSize jmeyer@Client2.com
            ###Results will return###
            Name            : Joshua Meyer
            MaxReceiveSize  : 36 MB (37,748,736 bytes)
            MaxSendSize     : 35 MB (36,700,160 bytes)
            RecipientLimits : 500

        .NOTES
            1. This will currently work in either the Client2 Environment or the Client1 Environment.
            2. This is Step 1 of the Exchange Admin Center Mac Form process via web knowledge base.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter The Email Address you want to check')]
$Email
)

Get-Mailbox -Identity $Email -ResultSize Unlimited | Where {$_.RecipientTypeDetails -eq 'UserMailbox'} | Format-List Name,MaxReceiveSize,MaxSendSize,RecipientLimits

}


##############################################MAC FORMS##############################################
####################################
###Check Mailbox Access to a User###
####################################
function Check-MailBox{
<#
        .SYNOPSIS
            This will check if a users Mailbox exist.

        .DESCRIPTION
            Check-MailBox is simply used just to check if a mailbox is existance or not prior to creating a new user via Mac Form process.

        .PARAMETER Email
            Specify the Email Address you want to look up to see if its in use.

        .EXAMPLE
            Check-MailBox ajmeyer@Client2.com
            ###Results will return: (Which means it does not exist)
            Get-Recipient: The operation couldn't be performed because object 'ajmeyer@Client2.com' couldn't be found on 'PROD.OUTLOOK.COM'.

            ###Results will return: (Which means it does exist)
            Name                 RecipientType
            ----                 -------------
            John Doe_98sdfEf2d05 UserMailbox

        .NOTES
            1. This will currently work in either the Client2 Environment or the Client1 Environment.
            2. This is Step 1 of the Exchange Admin Center Mac Form process via KB Link.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to check')]
$Email
)

Get-Recipient -Identity $Email

}





####################################
###Configure Outlook for Mac Form###
####################################
function Configure-MailBox{
<#
        .SYNOPSIS
            This will configure a users Mailbox for the Mac Form process.

        .DESCRIPTION
            Configure-Client2MailBox will do several things.
            1. Disables OWA & ActiveSync
            2. Adds Mailbox to the EWS BlockList on iOS/Android
            3. Enables Litigation Hold

        .PARAMETER Email
            Specify the Email Address you want to configure. Typically this is only when an account is created.

        .EXAMPLE
            Configure-MailBox joshua.meyer@Client1.com
            ###Results will return: (Which means it does not exist)

        .NOTES
            1. This will currently work in either the Client2 Environment or the Client1 Environment.
            2. This is Step 9 of the Exchange Admin Center Mac Form process via Online Knowledge Base.
    #>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to configure')]
$Email
)

Set-CASMailbox ($Email) -EwsBlockList @{Add="Outlook-iOS/*","Outlook-Android/*"} -OWAEnabled $false -ActiveSyncEnabled $false -OWAforDevicesEnabled $false

Set-Mailbox ($Email) -LitigationHoldEnabled $true

}

####################################
###Configure REHIRES for Mac Form###
####################################

function Configure-ReHire{
<#
.SYNOPSIS
            This will configure a REHIRES Mailbox for the Mac Form process.

        .DESCRIPTION
            Configure-Rehire will do several things.
            1. Set the Users MaxReceiveSize to whatever the MaxSendSize is set to.
            2. It will unhide the address from the Global Address List.
            3. It will convert the users account from a Shared mailbox to a Regular mailbox.

        .PARAMETER Email
            Specify the Email Address you want to configure.

        .EXAMPLE
            Configure-ReHire joshua.meyer@Client1.com
            ###Results will return:
            WARNING: The command completed successfully but no settings of 'Joshua Meyer' have been modified.

        .NOTES
            1. This will currently work in either the Client2 Environment or the Client1 Environment.
            2. This is REHIRE step of the Admin Center (Enable Mac Form) process via Online Knowledge Base Link.
#>
 [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to configure')]
$Email
)

#Set Mailbox Receive Size
$MaxSendSize = Get-Mailbox $Email | Select-Object -ExpandProperty MaxReceiveSize

Set-Mailbox -Identity $Email -MaxReceiveSize $MaxSendSize

#Unhide from GAL
Set-Mailbox -Identity $Email -HiddenFromAddressListsEnabled $False

#Convert to Regular Mailbox
Set-Mailbox -Identity $Email -Type Regular

}


########################################OUTLOOK WEB ACCESS######################################


##################
######ENABLE######
##################

function Enable-OWA{
<#
        .SYNOPSIS
            This will enable Outlook Web Access for a user.

        .DESCRIPTION
            Enable-OWA simply enables Outlook Web Access for an email that you choose.

        .PARAMETER Email
            Specify the Email Address you want to enable OWA for.

        .EXAMPLE
            Enable-OWA joshua.meyer@Client1.com

        .NOTES
            1. For security purposes OWA should be disabled by default for all users.
    #>
[Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to enable OWA for')]
$Email
)

Set-CASMailbox -Identity $Email -OWAEnabled $True

}



##################
######DISABLE#####
##################



function Disable-OWA{
<#
        .SYNOPSIS
            This will disable Outlook Web Access for a user.

        .DESCRIPTION
            Disable-OWA simply disables Outlook Web Access for an email that you choose.

        .PARAMETER Email
            Specify the Email Address you want to disable OWA for.

        .EXAMPLE
            Disable-OWA joshua.meyer@Client1.com

        .NOTES
            1. For security purposes OWA should be disabled by default for all users.
    #>
[Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to disable OWA for')]
$Email
)

Set-CASMailbox -Identity $Email -OWAEnabled $False

}



########################################SET OUT OF OFFICE######################################

############
###ENABLE###
############

function Enable-OOO{
<#
        .SYNOPSIS
            This will enable Out Of Office for a selected user.

        .DESCRIPTION
            Enable-OOO will enable Out Of Office for a specific user. You need to target the mailbox, set the internal message (Inside the Organizaiton) and external message (Outside of the Organizaiton).

        .PARAMETER EmailAddress
            The EmailAddress parameter is used for you to target the user you'd like to enable Out Of Office for.

        .PARAMETER ExternalMessage
            The ExternalMessage paramenter is used to specify the message that you want to be "auto-replied" to people outside of the organization.

         .PARAMETER ExternalMessage
            The InternalMessage paramenter is used to specify the message that you want to be "auto-replied" to people inside the organization.

        .EXAMPLE
            Enable-OOO joshua.meyer@Client1.com -Internal 'Message Hi Client1, im out of the office until 01/01/2050. Please call John.' -ExternalMessage 'Hi aliens, im out of the office until 01/01/2050. Please do not try to reach me.'
            ###This will enable OOO for Joshua Meyer with a message specific to Client1 and a message to everyone outside of Client1.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
    [Cmdletbinding()]
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to Enable Out Of Office for')]
$EmailAddress,
[Parameter(Mandatory=$True,
HelpMessage = 'Please enter the message youd like for it to say for External Users outside of the organization')]
$ExternalMessage,
[Parameter(Mandatory=$True,
HelpMessage = 'Please enter the message youd like for it to say for Internal Users inside of the organization')]
$InternalMessage
)


Set-MailboxAutoReplyConfiguration -Identity $EmailAddress -AutoReplyState Enabled -ExternalAudience:All -ExternalMessage $ExternalMessage -InternalMessage $InternalMessage

}

#############
###DISABLE###
#############

function Disable-OOO{
<#
        .SYNOPSIS
            This will disable Out Of Office for a selected user.

        .DESCRIPTION
            Disable-OOO will enable Out Of Office for a specific user.

        .PARAMETER EmailAddress
            The EmailAddress parameter is used for you to target the user you'd like to disable Out Of Office for.

        .EXAMPLE
            Disable-OOO joshua.meyer@Client1.com
            ###This will disable OOO for Joshua Meyer.

        .NOTES
            This will currently work in either the Client2 Environment or the Client1 Environment.
    #>
param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to Enable Out Of Office for')]
$EmailAddress
)

Set-MailboxAutoReplyConfiguration -Identity $EmailAddress -AutoReplyState Disabled

}

##############################
#####Enable Outlook Mobile####
##############################

function Enable-MobileOutlook{

param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to enable Outlook on Mobile for')]
$EmailAddress
)

Set-CasMailbox -Identity $EmailAddress -OutlookMobileEnabled $True
}

##############################
####Disable Outlook Mobile####
##############################

function Disable-MobileOutlook{

param(
[Parameter(Mandatory=$True,
HelpMessage = 'Enter the Email address youd like to Outlook on Mobile for')]
$EmailAddress
)

Set-CasMailbox -Identity $EmailAddress -OutlookMobileEnabled $False
}


########################################Client3 Accounts######################################

##############################
###Check for Disabled USers###
##############################

function Check-Client3DisabledUsers{
    #Checks if AzureAD is connected
    if (!(Get-AzureADTenantDetail)){
    Write-Host "Please Connect to Azure AD w/ the Client3 Tenant before proceeding"
    Connect-AzureAD}
    else{
        Get-AzureADUser -All $True | 
        Where-Object AccountEnabled -like "False" | 
        Where-Object Surname -ne $Null | 
        Where-Object DisplayName -NotLike "*TX*" | 
        Select-Object Displayname,UserPrincipalName
    }
}


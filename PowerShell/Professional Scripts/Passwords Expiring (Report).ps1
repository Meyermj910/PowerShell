#This script will look for users passwords who expires within the next 7 days

#Get Max Password Age Policy
$MaxPwdAge=(Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days

#Start Date (Gets current date)
$Startdate=(Get-Date).ToShortDateString()

#End Date (Gets current date + 7 days)
$Enddate=(Get-Date).AddDays(7).ToShortDateString()

#Report File Path
$File = 'C:\Reports\ExpiringPasswords.csv'
$FolderName = 'C:\Reports'

#Test if the directory exist, if not... Create one
if (Test-Path $FolderName) {
   
    Write-Host "Folder Exists"
}
else
{
  
    #PowerShell Create directory If It Does Not Exist
    New-Item $FolderName -ItemType Directory -
    Write-Host "Folder Created Successfully"
}

#Generating Report Message
Write-Host "Generating Report Now. Please Give It About 20 Seconds To Finish."

#This will query AD Users w/ a filter for the account to be active and their PasswordNeverExpires policy is equal to false
#It will grab all properties, select certain columns
#Then selects accounts that expire between todays date and 7 days out from now
#Sorts the CSV column by Expiration Date
#Exports file to a CSV file located in C:\Reports

$Report = Get-ADUser -Filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} –Properties Name, SamAccountName, EmailAddress, PasswordLastSet, Manager |
Select-Object -Property Name, SamAccountName, EmailAddress, @{l="PasswordExpiryDate";e={$_.PasswordLastSet.AddDays($MaxPwdAge)}}, @{N='Manager';E={ (Get-ADUser -Identity $_.Manager -Properties EmailAddress).EmailAddress }}|
Where-Object {(($_.PasswordExpiryDate) -lt $Enddate) -and (($_.PasswordExpiryDate) -gt $Startdate)} |
Sort-Object PasswordExpiryDate

#Export as CSV
$Report | Export-Csv -Path $File -Force -NoTypeInformation

#Email to Team/Manager/Director
$DeskOptions = @{
    'SmtpServer' = "smtprelay.server.com"
    'To' = "SServices@domain.com"
    'From' = "Alerts@domain.com"
    'Subject' = "Accounts Expiring (Within 20 Days)"
    'Body' = "Please review report, This shows a list of user account Passwords that will expire within the next 7 days."
    'Attachments' = $File
}

Send-MailMessage @DeskOptions

#####################################
#Get users manager email & email them
#####################################

$File2 = "C:\Reports\Attachments\How To Update Account Password.docx"



ForEach($_ in $Report){

 $UsersEmail = If($_.EmailAddress -eq $Null){
    then{Get-ADUser -Identity $_.SamAccountName -Properties extensionAttribute1 | Select-Object -ExpandProperty extensionAttribute1}

 $ManagersEmail = $_.Manager
 $PassExpDate = $_.PasswordExpiryDate
 $Days = New-TimeSpan -Start (Get-Date).ToString() -End ($_.PasswordExpiryDate) | Select-Object -ExpandProperty Days
 $Hours = New-TimeSpan -Start (Get-Date).ToString() -End ($_.PasswordExpiryDate) | Select-Object -ExpandProperty Hours
 $AccountName = $_.SamAccountName

$Options = @{  
 'SmtpServer' = "smtprelay.server.com"
 'To' = $UsersEmail,$ManagersEmail
 'From' = "Alerts@domain.com"
 'Subject' = "$AccountName Password Is Expiring"
 'Body' = 
"Hello, this is an automated notification to let you know that the Password for $AccountName is expiring on $PassExpDate which is within $Days day(s) & $Hours hour(s).. Please update your password as soon as possible. If you need assistance, please review the attachment. 

If you have any questions or concerns please email the Service Desk via support@domain.com or call (777)888-9999.

Service Desk
support@domain
(777)888-9999"


 'Attachments' = $File2

 }

 Send-MailMessage @Options

}

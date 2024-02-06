#This Script is to create a report showing the upcoming accounts to expire within the next 20 days & generate an eamil and attach a copy of the report to send it to the Service Desk

#Report File Path
$File = 'C:\Reports\ExpiringAccounts.csv'
$FolderName = 'C:\Reports'

if (Test-Path $FolderName) {
   
    Write-Host "Folder Exists"
}
else
{
  
    #PowerShell Create directory if not exists
    New-Item $FolderName -ItemType Directory -
    Write-Host "Folder Created successfully"
}

#Generating Report Message
Write-Host "Generating Report Now. Please Give It About 15 Seconds To Finish."

#This will Search AD Accounts that will expire within 20 days, grab the properties listed, and generate a CSV report to the selected location

Search-ADAccount -Server serverdomain.com -AccountExpiring -TimeSpan 20.00:00:00 | 
Select-Object -ExpandProperty SamAccountName | Get-ADUser -Properties * | 
Select-Object Name, SamAccountName,PasswordExpired, @{name ="Password Expiration Date";expression={$([datetime]::FromFileTime($_.pwdLastSet)).AddDays(60)}}, AccountExpirationDate, @{N='Manager';E={ (Get-ADUser $_.Manager).Name }} |
Export-Csv -Path $File -Force -NoTypeInformation


#Email to Team/Manager/Director
$Options = @{
    'SmtpServer' = "smtprelay.domain.com"
    'To' = "director.email@domain.com","j.m@domain.com"
    'From' = "Reports@domain.com"
    'Subject' = "Accounts Expiring (Within 20 Days)"
    'Body' = 
"Please review the report attached. This shows a list of user accounts that will expire within the next 20 days. If you need to extend any of these user accounts for another date, please open a ticket by emailing support at support@domain.com or call (777)888-9999 with the name of the user(s) you'd like to extend & what date you want to extend it to. Thanks.



If you have any questions or concerns please email the Service Desk via support@domain.com or call (777)888-9999.

Service Desk
support@domain.com
(777)888-9999"

    'Attachments' = $File
}

Send-MailMessage @Options
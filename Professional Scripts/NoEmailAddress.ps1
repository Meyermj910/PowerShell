#This script will look for users have no email address listed

#Report File Path
$File = 'C:\Reports\NoEmailAddress.csv'
$FolderName = 'C:\Reports'

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
Write-Host "Generating Report Now. Please Give It About 10 Seconds To Finish."

$Results = Get-ADUser -Properties * -Filter {Mail -notlike "*"} | Select-Object SamAccountName,EmailAddress

$Results | Export-Csv -Path $File -NoTypeInformation

#Opens File Location Of Report
Explorer 'C:\Reports'
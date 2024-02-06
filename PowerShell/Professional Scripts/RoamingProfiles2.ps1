#This script will look for users who have a roaming profile

#Report File Path
$File = 'C:\Reports\RoamingProfiles2.csv'
$FolderName = 'C:\Reports'
$Server = "DomainServer.com"

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

$Results = Get-ADUser -Server $Server -Filter '(ProfilePath -ne "$Null") -and (Enabled -eq $True)' | Select-Object SamAccountName

$Results | Export-Csv -Path $File -NoTypeInformation

#Opens File Location Of Report
Explorer 'C:\Reports'
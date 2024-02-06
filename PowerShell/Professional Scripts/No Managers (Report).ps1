#This script will look for users who do not have Managers listed

#Report File Path - Where you want the file to be stored
$File = 'C:\Reports\NAME_OF_FILE'
$FolderName = 'C:\Reports'

#Select Server
$Server = 'NAME_OF_SERVER'

#Filter Out OU
$OU = "OU PATH THAT YOU WANT TO FILTER"

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

Get-ADUser -Server $Server -Filter {Enabled -eq $True} –Properties Name, SamAccountName, Manager |
Where-Object {(($_.Manager) -eq $null -and $_.DistinguishedName -notlike "*,$OU")}  | Select-Object -Property Name, SamAccountName, Manager |
Sort-Object Name |
Export-Csv -Path $File -Force -NoTypeInformation

#Opens File Location Of Report
Explorer 'C:\Reports'
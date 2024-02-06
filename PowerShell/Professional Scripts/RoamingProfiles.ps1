#This script will look for users who have a roaming profile

#Report File Path
$File = 'C:\Reports\RoamingProiles.csv'
$FolderName = 'C:\Reports'
$Results = ""
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

$Users = Get-AdUser -Server $Server -filter * -Properties ProfilePath -Credential $Creds
#Creds variable is being pulled from a Password Vault#

foreach ($User in $Users){
$Username = $User.SamAccountName

if($User.ProfilePath -like "*Roaming*"){
$Results += New-Object PSObject -Property @{
'Username' = $Username
'Roaming Profile' = $True}
}else{
$Results += New-Object PSObject -Property @{
'Username' = $Username
'Roaming Profile' = $False}
}
}

$Results | Export-Csv -Path $File -NoTypeInformation

#Opens File Location Of Report
Explorer 'C:\Reports'
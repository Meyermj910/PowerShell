#Report File Path
$File = 'C:\Reports\ContractorAccounts2.csv'
$FolderName = 'C:\Reports'

#Generating Report Message
Write-Host "Generating Report Now. Please Give It About 15 Seconds To Finish."

if (Test-Path $FolderName) {
   
    Write-Host "Folder Exists"
}
else
{
  
    #PowerShell Create directory If It Does Not Exist
    New-Item $FolderName -ItemType Directory -
    Write-Host "Folder Created Successfully"
}

$Server = "DOMAIN_SERVER"
$List = Get-ADUser -Server $Server -Properties Description -Filter 'Description -like "*Contractor*"' -Credential "DOMAIN"\j | Select-Object -ExpandProperty SamAccountName

$DetailedList = foreach ($user in $list){

Get-ADUser -Server $Server -Identity $user -Properties Name,SamAccountName,Manager,Office,Title,Department,Description | Select-Object -Property Name,SamAccountName,@{N='Manager';E={ (Get-ADUser -Identity $_.Manager -Properties EmailAddress).EmailAddress }},Office,Title,Department,Description

}

#Export as CSV
$DetailedList | Export-Csv -Path $File -Force -NoTypeInformation

#Open File Explorer to Report Path
explorer C:\Reports
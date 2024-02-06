#Report File Path
$File = 'C:\Reports\ContractorAccounts.csv'
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


#List of VPN Groups
$adgroups = "VPN Access", "VPN Contractor2", "VPN DBA Access", "VPN NGA Access", "VPN Vendor Access", "VPN URL Access", "VPN Prod Access", "VPN TIS Access"

$List = foreach ($group in $adgroups){

Get-ADGroupMember -Identity $group | Select-Object -ExpandProperty samAccountName

}

$DetailedList = foreach ($user in $list){

Get-ADUser $user -Properties Name,SamAccountName,Manager,Office,Title,Department,Description | Select-Object -Property Name,SamAccountName,@{N='Manager';E={ (Get-ADUser -Identity $_.Manager -Properties EmailAddress).EmailAddress }},Office,Title,Department,Description

}

#Export as CSV
$DetailedList | Export-Csv -Path $File -Force -NoTypeInformation

#Open File Explorer to Report Path
explorer C:\Reports
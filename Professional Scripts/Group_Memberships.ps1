#Report File Path
$File = 'C:\Reports\GroupMemberships.txt'
$FolderName = 'C:\Reports'
$Users = "John.Doe","Jane.Smith"

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
Write-Host "Generating Report Now. Please Give It Some Time To Finish."

#Adjust Users as you see fit

#This will target the users above, and grab their security group and format it in a table view
$Groups = foreach ($User in $Users){

Write-Output "Group Membership for: $User"
Write-Output "-----------------------------------------"
Get-ADPrincipalGroupMembership -Identity $User | Select-Object Name, Groupcategory | Format-Table -HideTableHeaders
Write-Output "-----------------------------------------"

}
#This is to export the file as a .txt
$Groups | Out-File -FilePath $File -Force

Explorer C:\Reports
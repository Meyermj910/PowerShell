#Import Security groups from a text file
$FilePath = Read-Host "Enter File Path"
$Member = Read-Host "Enter UserName"

$Groups = Get-Content -Path $FilePath


#Loop through each group and add them
Foreach ($Group in $Groups){
Add-ADGroupMember -Identity $Group -Members $Member
}
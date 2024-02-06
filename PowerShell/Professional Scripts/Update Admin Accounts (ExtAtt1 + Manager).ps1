$File = "FILE PATH OF THE CSV FILE"

$Report = Import-Csv $File

ForEach($_ in $Report){

 $ManagerName = $_.Manager
 $AdminUserName = $_.SamAccountName
 $EmailAddress = $_.EmailAddress



 Set-AdUser -Identity $AdminUserName -Manager $ManagerName -Add @{extensionAttribute1="EmailAddress"}

}


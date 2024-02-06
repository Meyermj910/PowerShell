$File = "C:\Reports\Admin Accounts.csv"

$Report = Import-Csv $File

$Report2 =  ForEach($_ in $Report){

 [String]$UsersMainAccount = $_.Name
 $UsersMainAccount = $UsersMainAccount.Replace('Admin',"$null")

 $UsersFirstName = $UsersMainAccount.split()[0]
 $UsersLastName = $UsersMainAccount.split()[1]


 Get-ADUser -Identity "$UsersFirstName.$UsersLastName" -Properties EmailAddress,Manager | Select-Object -Property EmailAddress,Manager

}

$Report2 | Export-Csv -Path "C:\Reports\Admin Accounts Emails.csv" -Append
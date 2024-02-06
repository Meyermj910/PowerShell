$List = Import-Csv -Path "C:\Users\joshua.meyer\Downloads\List.csv" | Select-Object -ExpandProperty AccountName
$File = "C:\Reports\ExistReport.txt"

$Newlist = Foreach ($u in $List) {
    Try {
        $ADUser = Get-ADUser -Identity $u -ErrorAction Stop
    }
    Catch {
        If ($_ -like "*Cannot find an object with identity: '$u'*") {
            "User '$u' does not exist."
        }
        Else {
            "An error occurred: $_"
        }
        Continue
    }
    "User '$($ADUser.SamAccountName)' exists."
    # Do stuff with $ADUser
}

$Newlist | Out-File -Path $File -Force
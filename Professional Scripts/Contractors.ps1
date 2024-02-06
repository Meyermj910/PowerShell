$OU = "Contractor OU"

$Path = "C:\Reports\ContractorsOU.csv"

Get-ADUser -Filter * -SearchBase $OU | Select-Object Name,UserPrincipalName | Export-Csv -Path $Path -NoTypeInformation -Force
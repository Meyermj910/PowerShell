$Contractors = Import-Csv "C:\Reports\ContractorsOU.csv"
$Name = $Contractors.Name

foreach($User in $Name){

$LastName = $User.Split(" ")[-1]

if(Get-ADUser -Filter {DisplayName -like $LastName}){





}
}
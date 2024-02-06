#Import CSV Files
$RoamingProfiles = Import-Csv -Path "C:\Reports\RoamingProfileTrue.csv"


#Select each user, Then severe the roaming profile path
foreach($user in $RoamingProfiles){

Get-ADUser -Identity $_ -Properties ProfilePath | Set-ADUser -Clear ProfilePath

}
#Set value for "Servers" depending on your env
$Servers = "google.com","amazon.com"

#Set file path depending on your env
$FilePath = "C:\Reports\DNSName.csv"

#foreach, for each server selected and save it into a variable
$CSV = foreach($Server in $Servers){

Resolve-DnsName $Server -Type A | Select-Object Name,IPAddress

}

#Output the Variable into CSV file (No Type variable removes #TYPE from header / -Force is to overrwrite the current contents of that file)
$CSV | Export-Csv -Path $FilePath -NoTypeInformation -Force
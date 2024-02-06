#Set value for "Servers" depending on your env
$Servers = "8.8.8.8","9.9.9.9"

#Set file path depending on your env
$FilePath = "C:\Reports\DNSName.csv"

#Create format-table for writing to a table
$Table = New-Object psobject -Property @{
IPAddress = $null
Hostname = $null
}

#foreach, for each server selected and save it into a variable
$CSV = foreach($Server in $Servers){

$ResolvedDNS = Resolve-DnsName $Server

$IPAddress = $ResolvedDNS.Name.Replace(".in-addr.arpa","$null")

$HostName = $ResolvedDNS.NameHost

$Table | Add-Member NoteProperty "IPAddress" ($IPAddress)
$Table | Add-Member NoteProperty "HostName" ($HostName)

}

#Output the Variable into CSV file (No Type variable removes #TYPE from header / -Force is to overrwrite the current contents of that file)
$CSV | Export-Csv -Path $FilePath -NoTypeInformation -Force 
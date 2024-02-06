
function Get-SecurityGroup{
[CmdletBinding()]
[Parameter(Mandatory = $True)]
Param(
    $Username,
    $Server = 'domain.com'
)

(Get-ADUser -Server $Server -Identity $Username -Properties memberof) | % {$_.split(",")[0].replace("CN=","")}

}

 





#Xink Registry Values
$Path = "HKLM:\Software\Policies\Xink\Xink Client AD\ADConfig"
$Name = "DomainAuthToken"
$Value = "XINK_REGISTRY_KEY"

#This is to grab the value of the DomainAuthToken if it exist
$Token = (Get-ItemProperty -Path $Path -Name $Name -ErrorAction Silent)
$Token2 = $Token.DomainAuthToken

#This will test if the Token exist, if not > It will create the value
    if ($Token2 -like $Value){

Write-Warning "DomainAuthToken already exist in the registry path"

}

    else{
  
#PowerShell Create directory If It Does Not Exist
New-ItemProperty -Path $Path -Name $Name -Value $Value
Write-Warning "Successfully create DomainAuthToken"

}
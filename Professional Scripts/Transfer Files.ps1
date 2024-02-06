$ComputerName = Read-Host "Please Enter Computers Name"
$RemoteSession = New-PSSession -ComputerName $ComputerName

$From = Read-Host "Please enter the file path of the document"
$To = Read-Host "Please enter the location to transfer"

Copy-Item $From -Destination $To -ToSession $RemoteSession

Get-PSSession | Remove-PSSession
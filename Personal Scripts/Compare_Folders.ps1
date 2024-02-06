$folderPath1 = Read-Host "Enter the first folder path"
$folderPath2 = Read-Host "Enter the second folder path"

$itemsInFolder1 = Get-ChildItem -Path $folderPath1 -File | ForEach-Object { $_.BaseName }
$itemsInFolder2 = Get-ChildItem -Path $folderPath2 -File | ForEach-Object { $_.BaseName }

$missingItems = Compare-Object -ReferenceObject $itemsInFolder1 -DifferenceObject $itemsInFolder2 | Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -ExpandProperty InputObject

Write-Host "Items missing from $folderPath2 that are present in $folderPath1"
$missingItems
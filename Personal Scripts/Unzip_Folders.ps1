$sourceDirectory = "C:\Users\Shock\Downloads\FILE NAME)"
$destinationDirectory = "C:\Users\Shock\Downloads\FILE DIRECTORY"

$zipFiles = Get-ChildItem -Path $sourceDirectory -Filter "*.zip" -Recurse

foreach ($zipFile in $zipFiles) {
    $folderPath = Join-Path -Path $destinationDirectory -ChildPath $zipFile.Directory.Name
    Expand-Archive -Path $zipFile.FullName -DestinationPath $folderPath -Force
}
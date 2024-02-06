$folderPath = Read-Host "Please Copy & Paste the full file path of the directory."

$fileCount = (Get-ChildItem -Path $folderPath -File).Count

Write-Host "Number of files in the $folderPath :

$fileCount"
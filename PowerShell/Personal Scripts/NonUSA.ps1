# Specify the folder path
$folderPath = Read-Host "Please Copy & Paste the full file path of the directory."

# Create a subfolder if it doesn't exist
$subfolderPath = Join-Path -Path $folderPath -ChildPath "NonUSAFiles"
if (-not (Test-Path -Path $subfolderPath)) {
    New-Item -Path $subfolderPath -ItemType Directory
}

# Get the list of files in the folder
$files = Get-ChildItem -Path $folderPath

# Iterate through each file
foreach ($file in $files) {
    if ($file.Name -notmatch "USA") {
        # Move the file to the subfolder
        $destinationPath = Join-Path -Path $subfolderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $destinationPath -Force
        Write-Host "Moved $($file.Name) to $subfolderPath"
    }
}

Write-Host "Job Done"
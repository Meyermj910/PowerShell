# Specify the folder path
$folderPath = Read-Host "Please enter the Full File Path"

# Create the subfolder if it doesn't exist
$subFolderPath = Join-Path -Path $folderPath -ChildPath "Other"
if (-not (Test-Path -Path $subFolderPath)) {
    New-Item -Path $subFolderPath -ItemType Directory
}

# Get the list of files in the folder
$files = Get-ChildItem -Path $folderPath -File

# Keywords to search for in filenames
$keywords = @("Rev", "Beta", "Lodgenet", "Proto", "Demo")

# Loop through each file and check for the keywords
foreach ($file in $files) {
    $foundKeyword = $false
    foreach ($keyword in $keywords) {
        if ($file.Name -like "*$keyword*") {
            $foundKeyword = $true
            break
        }
    }

    if ($foundKeyword) {
        # Move the file to the subfolder
        $newFilePath = Join-Path -Path $subFolderPath -ChildPath $file.Name
        Move-Item -Path $file.FullName -Destination $newFilePath -Force
        Write-Host "Moved $($file.Name) to 'Other' folder."
    }
}

Write-Host "Finished moving files."
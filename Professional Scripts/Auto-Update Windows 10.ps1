# Get List of AD Computers not currently on 19044 & Export to local txt file
    Get-ADComputer -Filter {operatingsystem -like "Windows 10*" -and Operatingsystemversion 
    -notlike '*19044*'} -Properties OperatingSystemVersion | select -ExpandProperty Name | Format-Table | Out-File C:\Computers.txt

# Computer Name Variables
    $Computer = Get-Content C:\Computers.txt
    $filepath = \\$Computer\c$\

# Check if C:\source exist & create
    if (!(Test-Path $filepath)) {
    New-Item -Name 'Source' -ItemType Directory -Path $filepath
    }

# Copy Update.exe from local to remote machine & Script
    New-Item -Path \\$Computer\C$\Source -ItemType Directory
    Copy-Item -Path C:\Users\Administrator\Downloads\source\Windows10Upgrade9252.exe -Destination \\$Computer\C$\source
    Copy-Item -Path 'C:\Users\Administrator\Documents\PS Scripts\Start Upgrade.ps1' -Destination \\$Computer\C$\source

# Starting executable
   Invoke-Command -Computername $Computer {Start-Process -FilePath C:\Source\'start upgrade.ps1'}


#Make sure Microsoft App Installer "WinGet" is installed - Download from Microsoft Store
#Winget GITHUB location - https://github.com/microsoft/winget-cli

Write-Output "Installing Apps"
$apps = @(
    #Windows/Productivity
    @{name = "Google.Chrome";Folder="Google Chrome" },
    @{name = "Microsoft.PowerShell";Folder="PowerShell" },
    @{name = "Microsoft.VisualStudioCode";Folder="VisualStudioCode" },
    @{name = "Microsoft.WindowsTerminal";Folder="WindowsTerminal" },
    @{name = "Logitech.GHUB";Folder="Logitech GHUB" },
    @{name = "Notepad++.Notepad++";Folder="Notepad++" },
    @{name = "CPUID.CPU-Z";Folder="CPUZ" },
    @{name = "9WZDNCRFHWLH";Folder="HP Smart" }, #HP Smart
    @{name = "7zip.7zip";Folder="7zip" },
    #Communication
    @{name = "Discord.Discord";Folder="Discord" },
    #Game Launchers
    @{name = "Valve.Steam";Folder="Steam" },
    @{name = "EpicGames.EpicGamesLauncher";Folder="EpicGamesLauncher" },
    @{name = "ElectronicArts.EADesktop";Folder="EADesktop" },
    #Miscellaneous
    @{name = "XBMCFoundation.Kodi";Folder="Kodi" },
    @{name = "NordVPN.NordVPN";Folder="NordVPN" },
    @{name = "Git.Git";Folder="Git" }, #Bash for Terminal
    @{name = "9NBLGGH30XJ3";Folder="Xbox Accessories" } #Xbox Accessories (For Elite Controller)
);
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    $FolderName = $app.folder
    New-Item -ItemType Directory -Path "D:\Program Files\$FolderName"

    $InstallLocation = "D:\Program Files\$FolderName"

    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}

###################################################################################
##########################NVIDIA Geforce Driver Update#############################
###################################################################################


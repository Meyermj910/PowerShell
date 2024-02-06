#Make sure Microsoft App Installer "WinGet" is installed

Write-Output "Installing Apps"
$apps = @(
    @{name = "Google.Chrome" },
    @{name = "Microsoft.dotnet" },
    @{name = "Microsoft.PowerShell" },
    @{name = "Microsoft.VisualStudioCode" },
    @{name = "Microsoft.WindowsTerminal" },
    @{name = "Notepad++.Notepad++" }
);
Foreach ($app in $apps) {
    $listApp = winget list --exact -q $app.name
    if (![String]::Join("", $listApp).Contains($app.name)) {
        Write-host "Installing: " $app.name
        winget install -e -h --accept-source-agreements --accept-package-agreements --id $app.name 
    }
    else {
        Write-host "Skipping: " $app.name " (already installed)"
    }
}
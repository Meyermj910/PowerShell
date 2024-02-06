###This will enable Intellisense Prediction###
Set-PSReadLineOption -PredictionSource History

###OSCI Indicator (Small Circle at the top spinning)
$PSStyle.Progress.UseOSCIndicator=1

###Load Error Action Preferences###
Get-ChildItem variable:*pref*

<# Write-Host '
#Passing a Variable to a Remote Machine#
$using:(Variablename)

#VS Code Profile#
Type "code $profile" to load a txt to your profile
- Copy & Paste terminal profile in here and save it

###Connect to Exchange###
Connect-ExchangeOnline

###Check Module Commands###
Get-Help -Module SysAdmin/HelpDesk

' #>


###Set Speed Test Variable###
function Run-SpeedTest{

Invoke-Expression "C:\Users\User\OneDrive\SpeedTest\speedtest.exe"

}

###Changes Startup Directory###
cd "C:\"

###Clear The Screen###
cls

Write-Host '
Winget Package Installer
------------------------
winget (Shows all commands available for winget package manager)
winget upgrade (Shows all available packages for an update)
winget upgrade --all (Runs the update for all packages available)

WSL - Windows SubSystem for Linux
---
Type "wsl" and hit Enter to starting the Sub System for Linux and start using BASH

ADB - Android Debugging
---
adb (Get all ADB commands)
adb devices (list all devices)
adb pair "IPAddress/Port" (Pair via Wireless Debugging)
adb connect "IPAddress/Port" (Connect to device)
adb disconnect "IPAddress/Port" (Disconnect a device)
adb shell (Start a shell session on device)

- Once Remoted in
pm list packages (Show all packages)
pm list packages | grep "Package Name"
pm uninstall --user 0 "Package Name" (Uninstall a package)

'
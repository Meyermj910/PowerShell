###This will enable Intellisense Prediction###
Set-PSReadLineOption -PredictionSource History

###This will Import the Modules###
Import-Module ActiveDirectory
Import-Module ExchangeOnlineManagement
Import-Module ExchangePowerShell

#Customer Modules
Import-Module HelpDesk
Import-Module SysAdmin

###OSCI Indicator (Small Circle at the top spinning)
$PSStyle.Progress.UseOSCIndicator=1

###Load a help for a Command & Load an about section to review###
#Get-Command -Module Microsoft*,Cim*,PS* | Get-Random | Get-Help -ShowWindow
#Get-Random -input (Get-Help about*) | Get-Help -ShowWindow

###Clear The Screen###
cls

###Load Error Action Preferences###
Get-ChildItem variable:*pref*

Write-Host '
#Passing a Variable to a Remote Machine#
$using:(Variablename)

#VS Code Profile#
Type "code $profile" to load a txt to your profile
- Copy & Paste terminal profile in here and save it

###Connect to Exchange###
Connect-ExchangeOnline
'








###Enter your Credentials LOGS/A360###
$Client1Creds = (Get-Credential  -Message 'Enter your Client1 Admin Credentials' -UserName Client1\ajm )
$Client2Creds = (Get-Credential -Message 'Enter your Client2 Admin Credentials' -UserName Client2\ajm)

$Client1Server = 'domainclient1.com'
$Client2Server = 'domainclient2.com'








###Changes Startup Directory to C:\###
cd\
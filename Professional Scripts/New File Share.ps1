#Create New Folder
New-Item -Name LABS -ItemType Directory

#Create The Share
$myshare = New-SmbShare -name Labs -Path C:\Users\Administrator\Documents `
-Description "MoL Lab Share" -ChangeAccess Everyone `
-FullAccess Administrators -CachingMode Documents

#Get Share Permissions
$myshare | Get-SmbShareAccess
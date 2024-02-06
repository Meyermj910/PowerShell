<#
1. Run PowerShell as Administrator (Enter your creds).
2. Copy and paste all of the below commands to
 - Delete the Group Policy cache from C:\ProgramData\Microsoft\Group Policy\Users\*.*
 - Renaming the Registry.pol to Registry.old
 - Force a Group Policy update and a reboot once done
#>


###Delete Group Policy Cache###
Remove-Item C:\ProgramData\Microsoft\GroupPolicy\Users\* -Force
Sleep 1

Remove-Item "C:\ProgramData\Microsoft\Group Policy\Users\*" -Force
Sleep 1

###Rename Registry 
Rename-Item -Path C:\Windows\System32\GroupPolicy\Machine\Registry.pol -NewName Registry.old
Sleep 1

###Force GP Update###
gpupdate /force
Sleep 1

Restart-Computer -Force
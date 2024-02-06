#This is a test script#

#Set File Path Repository Location
$Path = '\\Server\Share\RepoName'

#Create The Repository
Import-Module PowerShellGet

$Repo = @{
       Name = 'MyRepository'
       SourceLocation = $Path
       PublishLocation = $Path
       InstallationPolicy = 'Trusted'
}

#Registers The Repository
Register-PSRepository @repo

#DONE
#Check To Make Sure Its Available
Get-PSRepository






###Publish Repository To Your Repo Location
#Verify Its In Correct Location
$env:PSModulePath

#Publish It
#This Will Package It As a NuGet Package and Deploy It To MyRepo
Publish-Module -Name 'Module Name' -Repository 'Repo Name' -Verbose

#List Repos
Find-Module -Repository 'Repo Name'

#Install Module
Install-Module -Name 'Module Name' -Repository 'Repo Name'

#To Update Module - Make Sure It Is In The Correct Module Location On Your Machine
Uninstall-Module -Name 'Module Name'
Install-Module -Name 'Module Name' -Repository 'Repo Name'












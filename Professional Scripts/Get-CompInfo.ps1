<#
.SYNOPSIS
This command is designed to provide basic computer info.
.DESCRIPTION
Get-Compinfo was designed to gather information from one or more computers targeted. It will gather the ComputerName, OS, Windows Edition, OS Build, & Free Space.
This also provides error logging information.
.PARAMETER ComputerName
This parameter supports multiple computer names to gather Data from. It is [Mandatory] & also have an [Alias] "Hostname".
.PARAMETER ErrorLog
This parameter is a [Switch] to turn on Error Logging.
.PARAMETER LogFile

.EXAMPLE
Getting information from the local computer.
PS C:\> Get-CompInfo -ComputerName .

ComputerName OS Name                  OS Build FreeSpace
------------ -------                  -------- ---------
.            Microsoft Windows 10 Pro 19044           32
.EXAMPLE
Getting information from remote computers.
Get-CompInfo -ComputerName Comp1,Comp2,DC1
.EXAMPLE
Getting information into a text file.
#>

Function Get-CompInfo{
    [CmdletBinding()]
    Param(
        #Want to support multiple computers
        [Parameter(Mandatory=$True,
                    ValueFromPipeline=$True,
                    ValueFromPipelineByPropertyName=$True,
                    HelpMessage = 'One or More Computer Name(s). Press Enter On A Blank Line To End The Script')]
        [Alias('HostName')]
        [String[]]$ComputerName,

        #Switch to turn on Error Logging.
        [Switch]$ErrorLog,
        [String]$LogFile = 'c:\errorlog.txt'
    )

Begin{
    If($ErrorLog){
        Write-Verbose "Error Logging Turned On"
    } Else {
        Write-Verbose "Error Logging Turned Off"
    }
    Foreach($Computer in $ComputerName){
        Write-Verbose "Computer: $Computer"
    }
    
}
Process{
    Foreach($Computer in $ComputerName){

      Try{
        $OS=Get-CimInstance -ComputerName $Computer -Class Win32_OperatingSystem -ErrorAction Stop -ErrorVariable CurrentError
        $Disk=Get-CimInstance -ComputerName $Computer -Class Win32_LogicalDisk -Filter "DeviceID='C:'"

        $Prop=[Ordered]@{
            'ComputerName' = $Computer
            'OS Name' = $OS.caption
            'OS Build' = $OS.buildnumber
            'FreeSpace(GB)' = $Disk.freespace / 1GB -as [int]
        }
        $Object=New-Object -TypeName PSObject -Property $Prop
        Write-Output $Object

    }
    Catch{
        Write-Warning "There is an issue with computer $Computer"
        If($ErrorLog){
            Get-Date | Out-File $LogFile -Force
            $Computer | Out-File $LogFile -Append
            $CurrentError | Out-File $LogFile -Append
        }
    }
    }
}
End{}


}

cd\
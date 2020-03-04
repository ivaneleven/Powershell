<# .SYNOPSIS
     Look up AD Subnet details from the machine name 
.DESCRIPTION
     WIP - Look up AD Subnet details from the machine name
.NOTES
     Author : Ivan Lau
#>


Function Get-MachineADSubnet{

    PARAM (
        [PARAMETER(Mandatory=$True,Position=0,HelpMessage="Specify Server name")]$computernames)

    Foreach($Computername in $Computernames){
        Write-host "Looking up $Computername"
        $output = Test-connection $computername | select IPv4Address
        $Output2 = $Output[0].IPV4Address.IPAddressToString -replace "((\d+\.){2}\d+).+",'$1'
        $SubnetLookup = Get-ADReplicationSubnet -filter * -Properties * | where-object {$_.name -like "*$output2*"}
        If ($SubnetLookup -ne $null){
            $OutputResult_Desc = $SubnetLookup.Description
            $OutputResult_CN = $SubnetLookup.CN
            write-host "$Computername is on the $OutputResult_Desc subnet ($OutputResult_CN)"
            }
        }
    }

<# .SYNOPSIS
     Server build scripts removal
.DESCRIPTION
     Removes c:\source folder (scripts used for automated server build) from all windows servers as per standard build
.NOTES
     Author : Ivan Lau
#>

$ErrorActionPreference = “Stop”
$date = get-date -uformat %Y%m%d
$servers = Get-ADComputer -Filter {OperatingSystem -Like "Windows *Server*"} | Select Name 
$OutArray = "" | Select "Server", "Output","Error"
#-File -Include *.ps1,*.cmd,*.psm1,*.bat -Recurse
        
        Foreach ($server in $servers.name){
                $OutArray.Server = $Server
                $OutArray.Output = ""
                $OutArray.Error = ""
                try {
                    Invoke-command -Computername $server -scriptblock {Remove-item c:\source -recurse -force -whatif} 
                    $Outarray.Output = Write-Output "Successfully removed folder"
                    }
                Catch [System.Management.Automation.RemoteException] {
                    $Outarray.Error = write-output "Source folder does not exist"
                    }
                Catch [System.Management.Automation.Remoting.PSRemotingTransportException] {
                    $Outarray.Error = write-output "Server is unreachable"
                    }
                Catch {
                    $Outarray.Error = write-output "an unknown error has occured"
                    }
                $OutArray | Export-CSV c:\temp\source-$date.csv -Append
                }

Send-mailmessage -to "noreply@domain.local" -from "sender@domain.local" -subject "Source folder removal report" -body "Please find attached the report for the automatic source folder removal task" -smtpserver "smtpserver.domain.local" -attachment "c:\temp\source-$date.csv"

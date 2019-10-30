#Snippet-Get SMB Session numbers from servers

$obj = @()
$servers = "SRV1","SRV2","SRV3","SRV4"
$Output = foreach ($server in $servers){
            $Sessions = Invoke-Command -ScriptBlock {(get-smbsession).count} -ComputerName $Server
                [PSCustomObject]@{
                "Servername" = $server
                "SMBSessionCount" = $Sessions
                "Time" = Get-Date -Format "MM/dd/yyyy HH:mm"
        }
        $Output += $Output
    }
$Output | Export-csv C:\temp\smbsessions.csv -append 

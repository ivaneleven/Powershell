#look up certificate with a particular thumbprint on all windows server on the domain

#Parameters
$ExportPath = "c:\temp\Report.csv"
$OutputTest = test-path $ExportPath 

#Check if output file exist, if not create file with headings
If ($OutputTest -eq $false){
    $props=[ordered]@{
     PSComputerName=''
     Subject=''
     Thumbprint=''}
     New-Object PsObject -Property $props | 
     Export-Csv $ExportPath -NoTypeInformation
     }

$Servers = Get-ADComputer -filter {(operatingsystem -like "*windows server*") -AND (enabled -eq $true)} | select Name,DistinguishedName
$Targets = $Servers.Name
    Foreach ($Target in $Targets){
        Write-Progress "Working on $Target"
        $CertLookup = Invoke-Command -ComputerName $Target -ScriptBlock {get-childitem cert:\localmachine\my} | where {$_.Thumbprint -eq "INSERT_THUMBPRINT_HERE"}  
                If ($CertLookup -ne $null){
                Write-Progress "Found entry on $Target for thumbprint, exporting..."
                $CertLookup | Select PSComputerName,Subject,Thumbprint | Export-csv $ExportPath -Append -NoTypeInformation
                }
            }






            

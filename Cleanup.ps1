

#Check if this is a RD server
$RD = Get-WindowsFeature | where-object {$_.name -eq "remote-desktop-services" -AND $_.Installed -eq "true"}
If ($RD.installed -eq 'true') {Write-host 'RDS role is install on this server'} else {Write-host 'RDS role is not installed'}


#Remove memory dumps older than 14 days
Write-host 'Searching for memory dumps older than 14 days' -ForegroundColor Yellow
$MemDumps = Get-Childitem -path c:\windows\* -Include *.dmp | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-0)}
    foreach ($MemDump in $MemDumps) {remove-item $memdump.fullname -whatif
    Write-host [Memory Dump] $memdump.fullname Removed
    }

#Clear c:\windows\temp folder
Write-host 'Searching for files to remove under c:\windows\temp' -ForegroundColor Yellow
$TempFiles = Get-Childitem -path c:\windows\temp\* -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-0)}
    foreach ($TempFile in $TempFiles) {remove-item $Tempfile.fullname -whatif
    $tfi++
    }
Write-host $tfi' files cleared from c:\windows\temp' -ForegroundColor Yellow

#
dism.exe /online /Cleanup-Image /StartComponentCleanup
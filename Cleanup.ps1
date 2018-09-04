
#Check if the scipt is running in an elevated powershell session
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq 'True')
    {
    Write-Host 'Running in an Elevated Powershell session, continuing' -ForegroundColor Yellow
    } 
    else
    {
    Write-Host 'This script must be run in an elevated Powershell session, exiting...' -ForegroundColor Red
    Break
    }

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

#Windows Error Report 
Write-host 'Searching Windows Error Report for removal' -ForegroundColor Yellow
$WERFiles = Get-Childitem -path C:\ProgramData\Microsoft\Windows\WER\ReportQueue\* -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-0)}
    foreach ($WERFile in $WERFiles) {remove-item $WERfile.fullname -whatif
    $WERi++
    }
Write-host $WERi' files cleared from C:\ProgramData\Microsoft\Windows\WER\ReportQueue\' -ForegroundColor Yellow    

#
$dism = dism.exe /online /Cleanup-Image /StartComponentCleanup
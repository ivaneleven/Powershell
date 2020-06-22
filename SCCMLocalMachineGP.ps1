<# .SYNOPSIS
     Fix SCEP/Windows Defender "Failed to open the local machine Group Policy" issue
.DESCRIPTION
     Fixes SCEP/Windows Defender "Failed to open the local machine Group Policy" issue, the script requires PSExec (part of PSTool), 
     suitable for environment where WinRM isn't enabled on workstations. 
     this is a work in progress, test thoroughly before use it in production.
.NOTES
     Author : Ivan Lau
#>

#Parameters
$ConfigMgrPath = 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1'
$PsExecPath = "e:\tools\pstools\psexec64.exe"
$PSExecBatchFilePath = "\\Server\SCCMLocalMachineGP\SCCMLocalMachineGP.bat"
$AllComputerResultPath = "c:\temp\FailedToOpenLocalMachineGP_All.log"
$LogOutputPath_success = "c:\temp\FailedToOpenLocalMachineGP_Success.log"
$LogOutputPath_failed = "c:\temp\FailedToOpenLocalMachineGP_Failed.log"

#Script
Import-Module $ConfigMgrPath
Set-Location P01:
$Computers = Get-CMCollectionMember -CollectionName 'Windows Defender Client At Risk' | Where{$_.EPPolicyApplicationDescription -eq "Failed to open the local machine Group Policy"} | Select Name
$Computers | Select Name, EPPolicyApplicationDescription | Out-File $AllComputerResultPath

    Foreach ($Computer in $Computers){
        $Target = $Computer.Name
        if (Test-connection -cn $Target -quiet) {
                write-host "working on $target"
                Start-Process -Filepath "$PSExecPath" -ArgumentList "\\$Target -accepteula -c $PSExecBatchFilePath" -Wait
                $Target | Out-File $LogOutputPath_success -append
                }  
        else {
        $Target | Out-File $LogOutputPath_failed -append
        }
    }

#check if powershell is running with admin privilege

function Test-Administrator  
{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}

If (Test-Administrator = True) {
    Write-host "Powershell is executed with Administrative privileges"
    }
Else {
    Write-host "This script needs to be executed with Administrative privileges, exiting"
    exit
    } 


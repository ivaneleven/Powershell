<# .SYNOPSIS
     Disable user account inactive for 45 days or more
.DESCRIPTION
     Disable user account inactive for 45 days or more, with logging and whitelist to exclude any accounts from being disabled. remove the -whatif switch before use
.NOTES
     Author : Ivan Lau
#>

$OU = "OU=Admins,DC=Domain,DC=local"
$WhitelistPath = "c:\temp\ExcludeFrom45DayInactiveDisable.txt"
$LogfilenameSuffix = Get-Date -Format "dd-MM-yyyy"
$Logfile = "c:\temp\45days_inactive_disable_$LogfilenameSuffix.log"
$LogEntryPrefix = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

#Check if script is run in an inactive session (invoked manually or by task scheduler)
Add-Content $Logfile "[$LogEntryPrefix] - Running script as $env:UserName"
if ([Environment]::UserInteractive){
    Add-Content $Logfile "[$LogEntryPrefix] - Script is running in an interactive session"}
    Else {
    Add-Content $Logfile "[$LogEntryPrefix] - Script is not running in an interactive session"}
 
# Check if whitelist is present
if (Test-path -path $WhitelistPath){
        $Whitelist = Get-Content $WhitelistPath
        Add-Content $Logfile "[$LogEntryPrefix] - Writelist present, exclding following users from whitelist: $whitelist"
    } else {
        Add-Content $Logfile "[$LogEntryPrefix] - Unable to find whitelist file at $whitelistpath, exiting script"
        Exit}

#Disabling Administrator accounts inactive for 45 days
Import-Module ActiveDirectory
$Users = Search-ADAccount -AccountInactive -TimeSpan 45 -UsersOnly -Searchbase "$OU" | Where-Object {($_.Enabled -eq $false) -and ($Whitelist -notcontains $_.samaccountname)}
$UserCount = $Users.count
Add-Content $Logfile "[$LogEntryPrefix] - found $UserCount administrator accounts matching criteria"
    Foreach ($User in $Users){
        Try{
            $UserAcct = $User.SamAccountName
            Set-ADUser -Identity $UserAcct -Replace @{Desscription="Account disabled due to inactive for 45 days"} -whatif | disable-ADAccount -whatif
            Add-Content $Logfile "[$LogEntryPrefix] - Disabling user $UserAcct"
            }
        Catch
            {
            Add-Content $Logfile "[$LogEntryPrefix] - An undetermined error occurred while attempting to disable account for user $UserAcct, Exception Type: $($_.Exception.GetType().FullName)"
            }
        }

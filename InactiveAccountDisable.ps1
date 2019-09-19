<# .SYNOPSIS
     Disables Inactive Account in a specific OU after 45 days of inactivity
.DESCRIPTION
     Disables account in a specific OU that are inactive for 45 or more days and excludes any accounts referenced in the file in $Whitelistpath, does not work in Powershell 2.0 due to the append switch has not yet been implemented for Export-CSV cmdlet
.NOTES
     Author : Ivan Lau
#>

$OU = "OU=Users,DC=Contoso,DC=Local"
$WhitelistPath = "c:\scripts\ITAdmin-ExcludeFrom45DayInactiveDisable.txt"
$LogfilenameSuffix = Get-Date -Format "dd-MM-yyyy"
$Logfile = "c:\temp\ITAdmin_45days_inactive_disable_$LogfilenameSuffix.log"
$UserList = "c:\temp\ITAdmin_45days_inactive_disable_$LogfilenameSuffix.csv"
$LogEntryPrefix = Get-Date -Format "dd-MM-yyyy HH:mm:ss"

#Check if script is run in an inactive session (invoked manually or by task scheduler)
Add-Content $Logfile "[$LogEntryPrefix] - [INF0] Running script as $env:UserName"
if ([Environment]::UserInteractive){
    Add-Content $Logfile "[$LogEntryPrefix] - [INF0] Script is running in an interactive session"}
    Else {
    Add-Content $Logfile "[$LogEntryPrefix] - [INF0] Script is not running in an interactive session"}

# Check if whitelist is present
if (Test-path -path $WhitelistPath){
        $Whitelist = Get-Content $WhitelistPath
        Add-Content $Logfile "[$LogEntryPrefix] - [INF0] Writelist present, exclding following users from whitelist: $whitelist"
    } else {
        Add-Content $Logfile "[$LogEntryPrefix] - [ERROR] Unable to find whitelist file at $whitelistpath, exiting script"
        Exit}

#Disabling Administrator accounts inactive for 45 days
Import-Module ActiveDirectory
$Users = Search-ADAccount -AccountInactive -TimeSpan 45.00:00:00 -UsersOnly -Searchbase "$OU" | Where-Object {($_.Enabled -eq $True)}
Foreach ($User in $Users)
{
        $UserAcct = $User.SamAccountName
        $WhitelistChk = $Whitelist | where{$_ -match "$($UserAcct)"}
            Try{
            If ($WhitelistChk -ne $null){
                Add-Content $Logfile "[$LogEntryPrefix] - [SKIP] $UserAcct is present in whitelist, skipping..."
                }
            ElseIf($WhitelistChk -eq $null){
                Get-ADUser $UserAcct -properties * | Select SAMAccountname, DisplayName, GivenName, Surname, Description, LastLogonDate, LogonCount | Export-CSV -path $UserList -append
                Set-ADUser -Identity $UserAcct -Replace @{Desscription="Account disabled due to inactive for 45 days, please obtain approval from manager before reenabling account."} -whatif | disable-ADAccount -whatif
                Add-Content $Logfile "[$LogEntryPrefix] - [DISABLE] Disabling user $UserAcct"
                }
            } Catch {
            Add-Content $Logfile "[$LogEntryPrefix] - [ERROR] An undetermined error occurred while attempting to disable account for user $UserAcct, Exception Type: $($_.Exception.GetType().FullName)"
            }
        }

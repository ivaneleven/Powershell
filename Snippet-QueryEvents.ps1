$Args = @{}
$Args.add("StartTime",((Get-Date).AddDays(-7)))
$Args.add("Endtime",(Get-Date))
$Args.add("LogName","System")
$Args.add("ID","10010")

$Workstations = Get-ADComputer -Filter * -SearchBase "OU=Workstations_Win10,DC=Domain,DC=Local" | Select-Object Name
Foreach ($Workstation in $Workstations){
    Write-host Working on $Workstation.name
    Get-WinEvent -ComputerName $Workstation.name -FilterHashTable $Args | ? { ($_.message -like "*Blah*")} |
    Export-CSV "C:\temp\Events.csv" -Append
    }



<# .SYNOPSIS
     Locate user home drive folders and run script to clean redirected recycle bins using Clean-RedirectedRecycleBin by Robert Prüst
.DESCRIPTION
     Look for user home drive folders on the server, transform the path into UNC path then run script to clean redirected recycle bins using Clean-RedirectedRecycleBin by Robert Prüst - work in progress, test thoroughly before using in production
.NOTES
     Author : Ivan Lau
#>


    Import-Module c:\Scripts\Clean-RedirectedRecycleBin.ps1 -force

    #Variables
    $L1Outputs = @() 
    $Date = Get-date -format ddMyyyy
    $Time = Get-date -format HH:mm:ss
    $Logpath = "c:\temp\UserRecyclebinCleanupLog"
    $Drives = get-psdrive -PSProvider FileSystem | where{$_.Root -ne 'A:\' -AND $_.Root -ne 'C:\' -AND $_.Root -ne 'Z:\' -AND $_.used -ne '0'}

    #Lookup top level folders with name matching the criteria
    Foreach ($Drive in $Drives){
        $Root = $Drive.Root
        Write-host "working on $Root"
        $L1Outputs += (Get-Childitem $Root | where{$_.PSIsContainer -AND $_.Name -like '*Userdata*'}).fullname
        }

    #Lookup second level Userdata folders and general a list of targets
    Foreach ($L1Output in $L1Outputs){
    Write-host "working on $L1Output"
        $Folders += (Get-Childitem -path "$L1Output").FullName
        }
 
    #Transform result into usable sharpaths then run clean-redirectedRecyclebin command
    Foreach ($Folder in $Folders){
        $FolderDrive = Split-path -Qualifier $Folder
        $FolderDrive_tf = $FolderDrive.Replace(":","$")
        $FolderName = $folder.Split('\')[-1]
        $ActualPath = "\\$env:COMPUTERNAME\$FolderDrive_tf\$Foldername"
        $Logpath_folder = "$Logpath\$foldername$Date.log"
        Add-Content -Path $LogPath_Folder -value "[$time] Commenceing clean-up at $ActualPath"
        Clean-RedirectedRecycleBin -SharePath '$actualpath' -Verbose -RetentionPeriod 1 #-Remove
        Add-Content -Path $LogPath_Folder -value "[$time] Completed clean-up at $ActualPath"
        }


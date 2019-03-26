<# .SYNOPSIS
     List all folders on all DFS Namespaces
.DESCRIPTION
     List all folders on all DFS Namespaces with their respective file server names for each folder targets
.NOTES
     Author : Ivan Lau
#>

Import-Module DFSN
$date = get-date -uformat %Y%m%d
Write-progress -Activity "Gathering all DFS-N Folder information"
$Namespaces = Get-DFSNroot | Where-Object {$_.state -eq "Online"}
$DFSFolders = 
    Foreach ($dfsnpath in $namespaces.path) { 
        Get-DFSNFolder -Path "$dfsnpath\*"
        Write-host $dfsnpath
    }

Write-progress -Activity "Generating Output, please wait"
$DFSFolderTgts = 
    Foreach ($DFSFolder in $DFSFolders) {
        $DFSFolderTgt = $DFSFolder.Path
        
        Get-DFSNFolderTarget -path "$DFSFoldertgt" | Format-Table Path,TargetPath,@{Name="Server";Expression={$_.targetpath.split("\")[2]}},state,ReferralPriorityClass,ReferralPriorityRank
    }

$DFSFolderTgts | Export-CSV -path "C:\temp\DFSNFolders-$date.csv"

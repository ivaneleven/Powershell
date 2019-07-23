$Location = \\Server.local\Share
$Folders = Get-ChildItem $Location | ?{ $_.PSIsContainer } | Select FullName
$OutArray = "" | Select "Path", "User","Rights","Type"
Foreach ($Folder in $Folders){
    $ACLs = Get-ACL $Folder.FullName
        Foreach ($ACL in $ACLs.access){
            $ACLProperties = $ACLs.access  
            $ACLProperties | Select @{l="Path";e={$Folder.FullName}}, FileSystemRights, AccessControlType, IdentityReference, IsInherited, InheritanceFlags, PropagationFlags | Export-csv c:\temp\permissions.csv -append
            }
        }

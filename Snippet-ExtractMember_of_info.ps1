$groups = Get-ADGroup -filter {name -like "*GroupPrefix*"}
foreach ($Group in $groups){
        $Outputs = Get-ADPrincipalGroupMembership $Group | Get-ADGroup -Properties * | select name, description
            foreach ($Output in $Outputs){
                [PSCustomObject]@{
                "GroupName" = $Group.Name
                "Member of" = $Output.Name
                "Description" = $Output.Description
        }
        }
 }
$Output | Export-CSV c:\temp\blah.csv 

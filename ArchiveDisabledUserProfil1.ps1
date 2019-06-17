$DisabledUsers = Get-ADUser -Properties * -Filter {enabled -eq "false" -and objectclass -eq "user" -and DisplayName -like "*disabled*" -and HomeDirectory -like "*Insert_Location*"}
    Foreach ($DisabledUser in $DisabledUsers)
    {
       
        Write-Host "Working on $DisabledUser.DisplayName $DisabledUser.SamAccountName"
        $FolderName = $DisabledUser.SamAccountName
        $newhomepath = "\\Server.domain.local\ArchiveData$\$FolderName"
           
            Write-Host "Moving folder to new location"
            Move-item -path $DisabledUser.HomeDirectory -destination $newhomepath
            Write-Host "Updating HomeDirectory path in AD profile"
            Set-ADUser $DisabledUser.SamAccountName -HomeDirectory "$NewHomePath"
            Out-file C:\temp\DisabledUserslog.txt
    }

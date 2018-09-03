#Monitors Webmarshal WMEngine logs for connection pool exceeding limit

$FolderTarget = "E:\Marshal\WebMarshal\logging\WMEngine"
$Keyword = "Connection pool size of 7500 exceeded" 
$FileToMonitor = Get-childitem "$FolderTarget" -exclude ScanEngine | sort LastWriteTime | select -last 1
If((Get-Content $FileToMonitor.fullname) -contains $Keyword)
{
write-eventlog -logname Application -source "WebMarshal Node Proxy" -EntryType Information -EventID 6969 -Message "Connection pool size of 7500 exceeded" 
}
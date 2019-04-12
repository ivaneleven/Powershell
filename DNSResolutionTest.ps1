$timestamp = get-date -format g
$domains = ('exap.um.outlook.com', 'google.com', 'nzherald.co.nz', 'youtube.com', 'atlassian.com', 'reddit.com', 'linkedin.com')

foreach ($domain in $domains)
{
    try
    {
        If (Resolve-DNSName -name $domain -ErrorAction Stop)
            { Add-content c:\temp\dnstestlog.txt "$timestamp $domain Resolved"}
    }
    Catch
    { Add-content c:\temp\dnstestlog.txt "$timestamp $domain DNS resolution Failed"}
}

<# .SYNOPSIS
     List Expired Trusted Root Certificates
.DESCRIPTION
     List Expired Trusted Root Certificates installed on the computer - work in progress
.NOTES
     Author : Ivan Lau
#>

#function Output-ExpiredRootCerts {

#Count certificates in the trusted root certificate and expired certificates in the store
$RootCertCountAll = (get-childitem cert:\localmachine\root).count
$RootCertCountExpired = (get-childitem Cert:\LocalMachine\root -recurse -expiringindays 0).count
Write-host "The number of Trusted Root Certificates on $env:computername is $RootCertCountAll" 
Write-host "The number of Expired Trusted Root Certificates on $env:computername is $RootCertCountExpired"

#Show expired certificates in the Trusted Root Certification Authority Store
Write-host "List of expired root certificates `n---------------------------------"
$RootCerts = get-childitem cert:\localmachine\root -ExpiringInDays 0
Foreach
    ($RootCert in $RootCerts)
        {
        $DisplaySub = $Rootcert.subject
        $DisplayThumb = $RootCert.Thumbprint
        $DisplayExpiry = $RootCert.NotAfter
        Write-Host "Subject: $DisplaySub `n  Thumbprint:$DisplayThumb `n  Expiry:$DisplayExpiry `n" -ForegroundColor Yellow
        }

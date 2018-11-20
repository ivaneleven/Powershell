<# .SYNOPSIS
     Expired Root Certificates removal script
.DESCRIPTION
     *REMOVING ROOT CERTIFICATES COULD ADVERSELY AFFECT YOUR SYSTEM - THIS IS A WORK IN PROGRESS - RUN FROM A TEST MACHINE FIRST*
     Removes expired certificates in the Trusted Root Certification Authority Store to prevent TLS communication issue due to store exceeding 16KB limit 
     and retain certificates required for normal server function.
.NOTES
     Author : Ivan Lau
#>

#Count certificates in the trusted root certificate and expired certificates in the store
$RootCertCountAll = (get-childitem cert:\localmachine\root).count
$RootCertCountExpired = (get-childitem Cert:\LocalMachine\root -recurse -expiringindays 0).count

#Trusted Root Certificates that should not be removed according to MS KB293781
$CertSerial_DoNotDelete = @("00c1008b3c3c8811d13ef663ecdf40","00","79ad16a14aa0a5ad4c7358f407132e65")

Write-host "The number of Trusted Root Certificates on is $RootCertCountAll"
Write-host "The number of Expired Trusted Root Certificates on is $RootCertCountExpired"

$RootCerts = get-childitem cert:\localmachine\root -recurse -expiringindays 0
Foreach
    ($RootCert in $RootCerts)
        {
        if ($CertSerial_DoNotDelete -Contains ($Rootcert.Thumbprint))
            {Write-Host "Certificate $RootCert.subject with thumbprint $RootCert.Thumbprint is marked as not to be deleted, skipping"}
        Else
            {
                $DisplaySub = $Rootcert.subject
                $DisplayThumb = $RootCert.Thumbprint
                $DisplayExpiry = $RootCert.NotAfter
                Get-Childitem cert:\localmachine\root -recurse | Where-Object {$_.Thumbprint -eq $Rootcert.Thumbprint} | Remove-item -whatif
                $i++
                Write-Host "Expired Certificate removed from Trusted Root Certificate store `n  Subject: $DisplaySub `n  Thumbprint:$DisplayThumb `n  Expiry:$DisplayExpiry" -ForegroundColor Yellow
            }
        }

if ($i = 0)
        {Write-host "Cleanup completed, $i Certificate(s) were removed from local Trusted Root Certificate store."}
    Else
        {Write-host "Cleanup completed, no certificate was removed from local Trusted Root Certificate store."}
        

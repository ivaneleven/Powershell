#look up specific licenses using the Microsoft Graph Powershell module and alerts when the counts reached warning threshold


Import-Module Microsoft.Graph
Connect-MgGraph `
    -ClientId "" `
    -TenantId "" `
    -CertificateThumbprint ""

#Parameters
$LicThreshold = 30
$EmailFrom = 'bleepbloop@Domain.local'
$EmailTo = 'bleepbloop@Domain.local'
$EmailBody = @"
    <p>The number of license available for M365 E3/M365 F1/Exchange Online P1 license have reach warning threshold of $LicThreshold, please consider procuring additonal licenses to ensure it does not run out. <br>
    <br>
    Available license for Microsoft 365 E3 is $M365E3_Avail <br>
    Available license for Microsoft 365 E3 is $M365F1_Avail <br>
    Available license for Microsoft 365 E3 is $EXOP1_Avail <br>
    </p>
"@

#Querying available licenses using Graph API
$M365E3 = (Get-MgSubscribedSku | where{$_.SkuPartNumber -eq "SPE_E3"})
$M365E3_Consumed = $M365E3.ConsumedUnits
$M365E3_Prepaid = $M365E3.prepaidunits.enabled
$M365E3_Avail = $M365E3_Prepaid - $M365E3_Consumed

$M365F1 = (Get-MgSubscribedSku | where{$_.SkuPartNumber -eq "SPE_F1"})
$M365F1_Consumed = $M365F1.ConsumedUnits
$M365F1_Prepaid = $M365F1.prepaidunits.enabled
$M365F1_Avail = $M365F1_Prepaid - $M365F1_Consumed

$EXOP1 = (Get-MgSubscribedSku | where{$_.SkuPartNumber -eq "EXCHANGESTANDARD"})
$EXOP1_Consumed = $EXOP1.ConsumedUnits
$EXOP1_Prepaid = $EXOP1.prepaidunits.enabled
$EXOP1_Avail = $EXOP1_Prepaid - $EXOP1_Consumed

if ($M365E3_Avail -OR $M365F1_Avail -OR $EXOP1_Avail -lt $LicThreshold){

Send-MailMessage -SmtpServer smtp@domain.local -From $EmailFrom -To $EmailTo -Subject "Alert - M365 License about to run out" -Body $EmailBody -BodyAsHtml
}

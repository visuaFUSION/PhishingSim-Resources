############################################
# Export-UsersForPhishingSim.ps1
# Author(s): Sean Huggans
$ScriptVersion = "24.11.15.2"
############################################
# Script will generate CSV of users intended for import into the visuaFUSION Phishing Simulator.
# first_name,last_name,email,phone

############################################
# Script Variables
################################
$StandardUserOUdn = "OU=Standard Users,OU=DHC-Users,DC=DHC,DC=demonstrationhealth,DC=com" # DN of the OU you wish to export list of users from

############################################
# Script Execution Logic
################################

$ExportPath = "$($env:USERPROFILE)\Documents\UserExport-$(Get-Date -format 'yyyyMMdd-HHmmss').csv"
"first_name,last_name,email,phone" | Out-File -FilePath $ExportPath -Encoding utf8 -Append
foreach ($ADUser in $(Get-ADUser -Filter {Enabled -eq $true} -SearchBase $StandardUserOUdn -SearchScope Subtree -Properties *)) {
    if (($ADUser.mail) -and ($ADUser.surName) -and ($ADUser.givenName)) {
        "$($ADUser.givenName),$($ADUser.surName),$($ADUser.mail),$($ADUser.OfficePhone)" | Out-File -FilePath $ExportPath -Encoding utf8 -Append
    } else {
        Write-Warning "$($ADUser.Name) ($($ADUser.SamAccountName)) is missing a first name, last name, or mail attribute and could not be added!"
    }
}


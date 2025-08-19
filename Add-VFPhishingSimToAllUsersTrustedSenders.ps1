#################################################
# Add-VFPhishingSimToAllUsersTrustedSenders.ps1 #
# Adds VisuaFUSION Phishing Simulator emails    #
# to All Mailboxes' trusted Senders Listes      #
#################################################
# Author(s): Sean Huggans
$ScriptVersion = "24.11.14.3"

#################################################
# Variables
#######################################

#################################################
# Functions
#######################################

#################################################
# Execution Logic
#######################################
if (!(Import-Module ExchangeOnlineManagement)) {
    Install-Module ExchangeOnlineManagement
    Import-Module ExchangeOnlineManagement
}

Connect-ExchangeOnline

$AllMailboxes = Get-Mailbox -RecipientTypeDetails UserMailbox -ResultSize Unlimited; 
$AllMailboxes.address
foreach ($Mailbox in $AllMailboxes) {
    $MailboxAddress = ""
    $MailboxAddress = $($Mailbox.EmailAddresses | Where-Object {$_ -clike "SMTP:*"}).Replace("SMTP:","").Trim()
    if ($MailboxAddress -ne "") {
        Write-Host $MailboxAddress
        Set-MailboxJunkEmailConfiguration -Identity $MailboxAddress -TrustedSendersAndDomains @{ add="visuafusion.com","accountmanage.net","auth-online.net","direct-auth.com","office-authenticate.com","tax-check.net","test.accountmanage.net","test.auth-online.net","test.direct-auth.com","test.office-authenticate.com","test.tax-check.net","dev.accountmanage.net","dev.auth-online.net","dev.direct-auth.com","dev.office-authenticate.com","dev.tax-check.net" }
    }
}



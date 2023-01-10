$Connection = Get-AutomationConnection -Name AzureRunAsConnection
# Get certificate from the automation account
$Certificate = Get-AutomationCertificate -Name AzureRunAsCertificate



Connect-MgGraph -ClientID $Connection.ApplicationId -TenantId $Connection.TenantId -CertificateThumbprint $Connection.CertificateThumbprint

$applications = Get-MgApplication -Property "id,appId,displayName,passwordCredentials"

# Iterate through the applications and print out the details
foreach ($application in $applications)
{
    # Print out the application ID, app ID, display name, and password credentials
    Write-Output "ID: $($application.id)"
    Write-Output "App ID: $($application.appId)"
    Write-Output "Display name: $($application.displayName)"
    Write-Output "Password credentials:"


foreach ($passwordCredential in $application.passwordCredentials)
    {
      
$currentDate = Get-Date
$dateToCheck = $passwordCredential.endDateTime
$daysToChekAgainst=30;  // check withIn the 30 days Window
$daysUntilDate = (New-TimeSpan -Start $currentDate -End $dateToCheck).Days

if ($daysUntilDate -lt $daysToChekAgainst) {
    Write-Output "Days left:  $daysUntilDate "
 Write-Output "  Type: Password"
        Write-Output "  Value: $($passwordCredential.value)"
        Write-Output "  End date time: $($passwordCredential.endDateTime)"
  Write-Output "  Key ID: $($passwordCredential.keyId)"

  $userId = "Dipesh@cqons.onMicrosoft.com"

# Prepare the message object
$message = @{
    subject = "Client secret is about to expire for $($application.displayName)"
    toRecipients = @(@{emailAddress = @{address = "Dipesh@cqons.onMicrosoft.com"}})
    body = @{
        contentType = "Text"
        content = "Hi Team, One of the client secret is going to expire from Azure app Name   $($application.displayName) registrationDetails   :ExpirationDate   $($passwordCredential.endDateTime) Location : https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Overview/appId/$($application.id)"
    }
}

# Send the email
Send-MgUserMail -UserId $userId -Message $message 
}
          
    
  
}

      
    }

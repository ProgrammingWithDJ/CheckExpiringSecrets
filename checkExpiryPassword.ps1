# Import the Azure AD module


#For RunBook-------------------------------------------------------------------------------
#$Connection = Get-AutomationConnection -Name AzureRunAsConnection
# Get certificate from the automation account
#$Certificate = Get-AutomationCertificate -Name AzureRunAsCertificate



# Connect to the Azure SDK endpoint using the automation account
#Connect-AzureAD -ApplicationId  $Connection.ApplicationId -TenantId $Connection.TenantId -CertificateThumbprint $Connection.CertificateThumbprint
#-----------------------------------------------------------


#-----------------------------------------------------------

#Graph Modules
#$Connection = Get-AutomationConnection -Name AzureRunAsConnection
# Get certificate from the automation account
#$Certificate = Get-AutomationCertificate -Name AzureRunAsCertificate



# Connect to the Graph SDK endpoint using the automation account
#Connect-AzureAD -ApplicationId  $Connection.ApplicationId -TenantId $Connection.TenantId -CertificateThumbprint $Connection.CertificateThumbprint

#-----------------------------------------------------------------------------

Import-Module AzureAD

# Connect to Azure AD
Connect-AzureAD

# Get the Azure AD applications
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
         if ($passwordCredential.endDateTime -eq $null) {
        # variable is null
      } else {

$currentDate = Get-Date
$dateToCheck = $passwordCredential.endDateTime

$daysUntilDate = (New-TimeSpan -Start $currentDate -End $dateToCheck).Days

if ($daysUntilDate -lt 14) {
    Write-Output "Days left:  $daysUntilDate "
 Write-Output "  Type: Password"
        Write-Output "  Value: $($passwordCredential.value)"
        Write-Output "  End date time: $($passwordCredential.endDateTime)"
  Write-Output "  Key ID: $($passwordCredential.keyId)"
}
          
    
  }
}


  $userId = "xx@cqons.onMicrosoft.com"

# Prepare the message object
$message = @{
    subject = "Test email sent using the Microsoft Graph API"
    toRecipients = @(@{emailAddress = @{address = "xxxx@cqons.onMicrosoft.com"}})
    body = @{
        contentType = "Text"
        content = "This is a test email sent using the Microsoft Graph API"
    }
}

# Send the email
Send-MgUserMail -UserId $userId -Message $message 


      
    }
    
    


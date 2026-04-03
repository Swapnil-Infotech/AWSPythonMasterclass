#Show which AWS identity is being used
try {
    $identity = Get-STSCallerIdentity
    Write-Host "Authenticated AWS Identity:"
    #Extract only username from the ARN
    $username = ($identity.Arn -split "/")[-1]
    #Mast account number and show first 4 digits, mask the rest
    $maskedaccount = $identity.Account.Substring(0,7) + "**"

    Write-Host "  Account: $maskedaccount"
    #Write-Host "  UserId : $($identity.UserId)"
    Write-Host "  User    : $username"
} catch {
    Write-Host "Unable to retrieve AWS identity. Check your credentials."
} 

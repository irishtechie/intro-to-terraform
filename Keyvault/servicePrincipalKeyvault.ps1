function servicePrinicpalKeyvault {
    [cmdletbinding()]
    param(
        [string]$name = "sp-keyvault-cloudskills",
        [string]$resourceGroup = "rg-KC-CloudSkillsTF",
        [string]$location = "northeurope",
        [string]$clientID = "b6093da6-1f93-47c1-a47c-1eb26eecabf4"
    )

    try {
        $createKeyVault = az keyvault create --location $location --name $name --resource-group $resourceGroup
        $createKeyVault
    }
    catch {
        Write-Warning 'An error has occurred. Please ensure the vault created properly...'
        $PSCmdlet.ThrowTerminatingError($_)
    }

    try {
        #Connect-AzAccount -Subscription $azureSubscription
        $ID = (Get-AzADServicePrincipal -ServicePrincipalName $clientID)
        az keyvault set-policy --name $name --object-id $ID.Id --secret-permissions get list
    }
    catch {
        Write-Warning "KeyVault permissions for $name were not set..."
        $PSCmdlet.ThrowTerminatingError($_)
    }

    if ($PSCmdlet.ShouldProcess('name')) {
        try {
            $createKeyVault.Id
        }
        catch {
            Write-Warning 'KeyVault vault does not exist...'
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }
}
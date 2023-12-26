Connect-AzAccount

$azSubs = Get-AzSubscription

$azPolicy = @()


foreach ($azSub in $azSubs) {
    Set-AzContext $azSub.id | Out-Null

    $nonCompliantResources = Get-AzPolicyState | Where-Object { $.PolicyDefinitionName -eq "stPubAccess" -and $.ComplianceState -eq "NonCompliant" }

    foreach ($resource in $nonCompliantResources) {
        $resourceName     = $resource.resourceId.Split('/')[-1]
        $complianceState  = $resource.complianceState
        $resourceGroup    = $resource.resourceGroup
        $myObject = [PSCustomObject]@{
            ResourceName = $resourceName;
            ResourceGroup = $resourceGroup;
            ComplianceState = $complianceState;
            Subscription = $azSub.Name
        }
        $azPolicy += $myObject
    }
}

$azPolicy | export-csv "PublicAccess_Non-Compliance.csv"
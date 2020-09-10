function Update-TFVars {
    [cmdletbinding()]
    param(
        [parameter(Mandatory)]
        [string]$location,

        [parameter(Mandatory)]
        [string]$resourceGroupName
    )

    try {
        $(Get-Content -path .\Part-II-Project\Virtual-Machines\Terraform-VMs\VMs\terraform.tfvars -Raw) -replace 'eastus', $location
        $(Get-Content -path .\Part-II-Project\Virtual-Machines\Terraform-VMs\VMs\terraform.tfvars -Raw) -replace 'NoBSDevOpsMonolith', $resourceGroupName
    }

    catch {
        $pscmdlet.ThrowTerminatingError($_)
    }

}
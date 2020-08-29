param(
    [string]$name = 'NoBSKV',
    [string]$rgName = "NoBS",
    [string]$location = 'eastus'
)

az keyvault create --name $name `
                   --resource-group $rgName `
                   --location $location
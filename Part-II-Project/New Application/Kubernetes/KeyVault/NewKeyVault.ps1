param(
    [string]$name,
    [string]$rgName,
    [string]$location
)

az keyvault create --name $name `
                   --resource-group $rgName `
                   --location $location
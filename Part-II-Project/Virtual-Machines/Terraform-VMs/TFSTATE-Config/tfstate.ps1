function New-TFStateStorage {
    [cmdletbinding()]
    param(
        [parameter(Mandatory,
            HelpMessage = 'The new storage account that will be created for the TFSTATE')]
        [string]$storageAccountName = "nobsstorage",

        [parameter(Mandatory,
            HelpMessage = 'The resource group name that the storage account will reside in')]
        [string]$resourceGroupName = "NoBS",

        [parameter(Mandatory,
            HelpMessage = 'Location for the storage account')]
        [string]$location = "eastus",

        [parameter(Mandatory,
            HelpMessage = 'Container name')]
        [string]$container = "tfstate"
    )

    begin {

    }

    process {
        az group create --name $resourceGroupName --location $location

        az storage account create --resource-group $resourceGroupName --name $storageAccountName --sku Standard_LRS --encryption-services blob
    
        ACCOUNT_KEY=$(az storage account keys list --resource-group $resourceGroupName --account-name $storageAccountName --query [0].value -o tsv)
    
        az storage container create --name $container --account-name $storageAccountName --account-key $ACCOUNT_KEY
    }

    end {

    }
}
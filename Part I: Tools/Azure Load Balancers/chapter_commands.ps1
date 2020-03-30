$projectName = 'NoBSAzureLb'

$resourceGroupName = "$projectName-Lb"
$location = 'eastus'

## Create the resource group
az group create --name $resourceGroupName --location $location

## Create the public IP
$pipName = "$projectName-pip"

## Must capture this to provide to the Load balancer frontend IP configuration later
$pubIp = az network public-ip create --name $pipName --allocation-method Static --location $location --resource-group $resourceGroupName | ConvertFrom-Json

## Create the vNet
$vNetName = "$projectName-vNet"
az network vnet create --resource-group $resourceGroupName --name $vNetName --address-prefixes '10.0.0.0/16'
 
## subnet
$subNetName = "$projectName-Subnet"
az network vnet subnet create --address-prefixes '10.0.0.0/24' --name $subNetName --resource-group $resourceGroupName --vnet-name $vNetName

## Create the load balancer
$lbName = "$projectName-Lb"
az network lb create --resource-group $resourceGroupName --name $lbName --sku Basic

## Create the frontend IP pool
$lbFeIp = "$projectName-LbFeIp"
az network lb frontend-ip create --lb-name $lbName --name $lbFeIp --resource-group $resourceGroupName --public-ip-address $pubIp.publicip.id

## Create the backend IP pool



## Create the health probe



## Create the VM avaialability set

## Create the VMs to place into the availability set

## Install the custom script extension on the VMs and install IIS

## Cleaning up
$projectName = 'NoBSAzureLb'

$resourceGroupName = "$projectName-Lb"
$location = 'eastus'

#region Create the resource group
az group create --name $resourceGroupName --location $location
#endregion

#region Create the public IP
$pipName = "$projectName-pip"

## Must capture this to provide to the Load balancer frontend IP configuration later
$pubIp = az network public-ip create --name $pipName --allocation-method Static --location $location --resource-group $resourceGroupName | ConvertFrom-Json
#endregion

#region Create the vNet and subnet
$vNetName = "$projectName-vNet"
az network vnet create --resource-group $resourceGroupName --name $vNetName --address-prefixes '10.0.0.0/16'
 
## subnet
$subNetName = "$projectName-Subnet"
az network vnet subnet create --address-prefixes '10.0.0.0/24' --name $subNetName --resource-group $resourceGroupName --vnet-name $vNetName
#endregion

#region Create the load balancer
$lbName = "$projectName-Lb"
az network lb create --resource-group $resourceGroupName --name $lbName --sku Basic
#endregion

#region Create the frontend IP pool
$lbFeIp = "$projectName-LbFeIp"
az network lb frontend-ip create --lb-name $lbName --name $lbFeIp --resource-group $resourceGroupName --public-ip-address $pubIp.publicip.id
#endregion

#region Create the backend IP pool

#endregion

#region Create the health probe

#endregion

#region Create the VM avaialability set

#endregion

#region Create the VMs to place into the availability set

#endregion

#region Install the custom script extension on the VMs and install IIS

#endregion

#region Cleaning up

#endregion
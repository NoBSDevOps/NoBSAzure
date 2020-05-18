az group create --name NoBSDevOps --location "East US"

az group deployment create \
  --name NoBSDevOpsDeployment \
  --resource-group NoBSDevOps \
  --template-file azuredeploy.json \
  --parameters @azuredeploy.parameters.json

  az group remove --name NoBSDevOps --location "East US"
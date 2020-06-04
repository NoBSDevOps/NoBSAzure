param(
    [string]$resourceGroup = 'NoBSDevOps',
    [string]$appName = 'nginx-web-app',
    [string]$imageName = 'nginx',
    [string]$cpu = 1,
    [string]$memory = 1
)

az container create -g $resourceGroup `
                    --name $appName `
                    --image $imageName `
                    --cpu $cpu `
                    --memory $memory
# This code does two things:
# 1. Creates a new app registration
# 2. Takes the client ID and password, then stores them in Key Vault

param(
    [string]$name = "nobsapp",
    [string]$rgName = "NoBS"
)

$account = az account show | ConvertFrom-Json | Select -ExpandProperty id

$appReg = az ad sp create-for-rbac -n $name `
                                   --role contributor `
                                   --scopes "subscriptions/$account/resourceGroups/$rgName"

$appReg | ConvertFrom-Json
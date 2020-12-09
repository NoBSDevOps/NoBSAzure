terraform {
  backend "azurerm" {
    resource_group_name = "NoBS"
    storage_account_name = "NoBSTFState"
    container_name = "tfstate"
    key = "terraform.state"
  }
}

provider azurerm {
  version = "2.0.0"
  features {}
}

data "azurerm_key_vault_secret" "keyVaultClientID" {
  name         = "AKSClientID"
  key_vault_id = var.keyvaultID
}

data "azurerm_key_vault_secret" "keyVaultClientSecret" {
  name         = "AKSClientSecret"
  key_vault_id = var.keyvaultID
}

output "ClientID" {
  value = "${data.azurerm_key_vault_secret.keyVaultClientID.value}"
}

output "ClientSecret" {
  value = "${data.azurerm_key_vault_secret.keyVaultClientSecret.value}"
}

resource "azurerm_kubernetes_cluster" "NoBSAKS" {
  name                = var.Name
  location            = var.location
  resource_group_name = var.resourceGroup
  dns_prefix          = "nobsprefix"

  default_node_pool {
    name = "default"
    node_count = 1
    vm_size = "Standard_D2_v2"
  }
  service_principal {
    client_id     = "${data.azurerm_key_vault_secret.keyVaultClientID.value}"
    client_secret = "${data.azurerm_key_vault_secret.keyVaultClientSecret.value}"
  }
}

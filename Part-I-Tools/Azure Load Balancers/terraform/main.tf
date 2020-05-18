provider "azurerm" {
  version = "2.0.0"
  features {}
}

resource "azurerm_public_ip" "NoBS-PubIP" {
  name = "NoBSPublicIP"
  location = var.location
  resource_group_name = var.resourceGroupName
  allocation_method = "Static"
}

resource "azurerm_lb" "NoBS-LB" {
  name = var.name
  location = var.location
  resource_group_name = var.resourceGroupName

  frontend_ip_configuration {
      name = "NoBSPublicIP"
      public_ip_address_id = azurerm_public_ip.NoBS-PubIP.id
  }
}



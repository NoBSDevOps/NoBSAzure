provider "azurerm" {
  version = "2.0.0"
  features {}
}

resource "azurerm_public_ip" "LBIP" {
  name                = "PubIPforLoadBalancer"
  location            = "East US"
  resource_group_name = var.resourceGroup
  allocation_method   = "Static"
}

resource "azurerm_lb" "MonolithLB" {
  name                = var.LBName
  location            = var.location
  resource_group_name = azurerm_public_ip.LBIP.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.LBIP.id
  }
}
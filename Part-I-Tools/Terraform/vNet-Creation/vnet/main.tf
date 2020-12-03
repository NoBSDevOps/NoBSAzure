provider "azurerm" {
  version         = "2.0.0"
  subscription_id = var.subscriptionID

  features {}
}

resource "azurerm_resource_group" "NoBS" {
  name     = "NoBSDevOps"
  location = var.location
}


resource "azurerm_network_security_group" "NoBS-SG" {
  name                = "NoBSSG"
  location            = var.location
  resource_group_name = var.resourceGroupName
}

resource "azurerm_virtual_network" "NoBS-vnet" {
  name                = "nobs-vnet"
  location            = var.location
  resource_group_name = var.resourceGroupName
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["8.8.8.8", "8.8.4.4"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "NoBS-sub" {
  name                 = "nobssubnet"
  resource_group_name  = azurerm_network_security_group.NoBS-SG.resource_group_name
  virtual_network_name = azurerm_virtual_network.NoBS-vnet.name
  address_prefix       = "10.0.1.0/24"
}

resource "azurerm_network_interface" "VMInterface" {
  name                = "VMInterface"
  location            = azurerm_network_security_group.NoBS-SG.location
  resource_group_name = azurerm_network_security_group.NoBS-SG.resource_group_name

  ip_configuration {
    name                          = "DevConfig1"
    subnet_id                     = azurerm_subnet.NoBS-sub.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    environment = "staging"
  }
}

provider "azurerm" {  
  version = "2.0.0"  
  subscription_id = var.subscriptionID  
  
  features {}

}

## This resource creates the resource group to store all of the vNet resources in,
## like the network security group, for example.
resource "azurerm_resource_group" "NoBS" {  
  name     = "NoBSDevOps"  
  location = var.location
}

## This resource is to create a network security group (NSG). Think of an NSG 
## like a firewall.
resource "azurerm_network_security_group" "NoBSSG" {  
  name                = "nobsSG"  
  location            = "eastus"  
  resource_group_name = var.resourceGroupName
}

## This resource creates the virtual network (vNet) itself. The primary
## parameter it contains is the address_space, which is the CIDR range that
## will be associated with the vNet.
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

## This resource creates the subnet that will be inside of the vNet for handing
## out IP addresses from a specific subnet range.
resource "azurerm_subnet" "nobs-sub" {  
  name                 = "testsubnet"  
  resource_group_name  = azurerm_network_security_group.NoBSSG.resource_group_name  
  virtual_network_name = azurerm_virtual_network.nobs-vnet.name  
  address_prefix       = "10.0.1.0/24"
}

tags = {    
  environment = "staging"
 }
}

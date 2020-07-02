provider "azurerm" {
  version = "2.0.0"
  features {}
}

resource "azurerm_virtual_network" "monolvmss-network" {
  name                = "vmss-net"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resourceGroup
}

resource "azurerm_subnet" "monolvmss-subnet" {
  name                 = "acctsub"
  resource_group_name  = var.resourceGroup
  virtual_network_name = azurerm_virtual_network.monolvmss-network.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "monolvmss-pubip" {
  name                = "test"
  location            = var.location
  resource_group_name = var.resourceGroup
  allocation_method   = "Static"
  domain_name_label   = "vmssdeploy"

}

resource "azurerm_lb" "monolvmss-lb" {
  name                = "nobsmonol"
  location            = var.location
  resource_group_name = var.resourceGroup

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.monolvmss-pubip.id
  }
}

resource "azurerm_lb_backend_address_pool" "monolvmss-backend" {
  resource_group_name = var.resourceGroup
  loadbalancer_id     = azurerm_lb.monolvmss-lb.id
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_nat_pool" "monolvmss-pool" {
  resource_group_name            = var.resourceGroup
  name                           = "rdp"
  loadbalancer_id                = azurerm_lb.monolvmss-lb.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "monolvmss-probe" {
  resource_group_name = var.resourceGroup
  loadbalancer_id     = azurerm_lb.monolvmss-lb.id
  name                = "http-probe"
  protocol            = "Http"
  request_path        = "/health"
  port                = 8080
}

resource "azurerm_virtual_machine_scale_set" "monolvmss-vmss" {
  name                = "monolvmss-vmss"
  location            = var.location
  resource_group_name = var.resourceGroup

  automatic_os_upgrade = false
  upgrade_policy_mode  = "Manual"

  sku {
    name     = "Standard_F2"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

    os_profile_windows_config {

  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "TestIPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.monolvmss-subnet.id
      load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.monolvmss-backend.id]
      load_balancer_inbound_nat_rules_ids    = [azurerm_lb_nat_pool.monolvmss-pool.id]
    }
  }

  tags = {
    environment = "staging"
  }
}

provider "azurerm" {
  version = "2.0.0"
  features {}
}

resource "azurerm_resource_group" "monolithRG" {
  name     = var.resource_group
  location = var.location
}

resource "azurerm_availability_set" "monolith-as" {
  name                = "monolith-as"
  location            = azurerm_resource_group.monolithRG.location
  resource_group_name = azurerm_resource_group.monolithRG.name
}

resource "azurerm_network_security_group" "monolithnsg" {
  name                = "allowssh"
  location            = azurerm_resource_group.monolithRG.location
  resource_group_name = azurerm_resource_group.monolithRG.name

  security_rule {
    name                       = "allowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "allowWinRm"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5986"
    source_address_prefix      = var.cloud_shell_source
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "monolith-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.monolithRG.location
  resource_group_name = azurerm_resource_group.monolithRG.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.monolithRG.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"

  depends_on = [
    azurerm_virtual_network.main
  ]
}

resource "azurerm_public_ip" "vmIps" {
  count                   = 2
  name                    = "publicVmIp-${count.index}"
  location                = azurerm_resource_group.monolithRG.location
  resource_group_name     = azurerm_resource_group.monolithRG.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_public_ip" "lbIp" {
  name                    = "publicLbIp"
  location                = azurerm_resource_group.monolithRG.location
  resource_group_name     = azurerm_resource_group.monolithRG.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "main" {
  count               = 2
  name                = "monolith-nic-${count.index}"
  location            = azurerm_resource_group.monolithRG.location
  resource_group_name = azurerm_resource_group.monolithRG.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vmIps[count.index].id
  }

  depends_on = [
    azurerm_subnet.internal
  ]
}

resource "azurerm_network_interface_security_group_association" "nsg" {
  count                     = 2
  network_interface_id      = azurerm_network_interface.main[count.index].id
  network_security_group_id = azurerm_network_security_group.monolithnsg.id
}

resource "azurerm_lb" "LB" {
 name                = "nobsloadbalancer"
 location            = azurerm_resource_group.monolithRG.location
 resource_group_name = azurerm_resource_group.monolithRG.name

 frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id = azurerm_public_ip.lbIp.id
 }
}

resource "azurerm_lb_backend_address_pool" "test" {
 resource_group_name = azurerm_resource_group.monolithRG.name
 loadbalancer_id     = azurerm_lb.LB.id
 name                = "BackEndAddressPool"
}

resource "azurerm_windows_virtual_machine" "monolithVMs" {
  count                 = 2
  name                  = "monolithvm-${count.index}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.monolithRG.name
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.main[count.index].id]
  availability_set_id   = azurerm_availability_set.monolith-as.id
  computer_name         = "hostname"
  admin_username        = "testadmin"
  admin_password        = "Password1234!"
  
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = {
    environment = "staging"
  }

  depends_on = [
    azurerm_network_interface.main
  ]
}

output "VMIps" {
  value       = [azurerm_public_ip.vmIps.*.ip_address]
}

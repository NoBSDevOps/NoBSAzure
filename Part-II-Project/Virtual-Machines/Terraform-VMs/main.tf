provider "azurerm" {
    version = "2.0.0"
    features {}
}

resource "azurerm_resource_group" "monolithRG" {
    name     = "monolithRG"
    location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "monolith-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.monolithRG.location
  resource_group_name = azurerm_resource_group.monolithRG.name

      depends_on = [
        azurerm_resource_group.monolithRG
  ]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.monolithRG.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefix       = "10.0.2.0/24"

      depends_on = [
        azurerm_resource_group.monolithRG
  ]
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
  }

      depends_on = [
        azurerm_resource_group.monolithRG
  ]
}

resource "azurerm_virtual_machine" "monolithVMs" {
    count = 2
    name  = "monolithvm-${count.index}"
    location = var.location
    resource_group_name = azurerm_resource_group.monolithRG.name
    vm_size               = "Standard_DS1_v2"
    network_interface_ids = [azurerm_network_interface.main[count.index].id]

storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {

  }

  tags = {
    environment = "staging"
  }

        depends_on = [
        azurerm_resource_group.monolithRG
  ]
}
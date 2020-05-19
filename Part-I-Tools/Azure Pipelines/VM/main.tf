provider "azurerm" {
  version         = "1.38.0"
  subscription_id = var.subscriptionID
}

resource "azurerm_virtual_machine" "NoBSDevVM" {
  name                  = "nobssvm"
  location              = var.location
  resource_group_name   = var.resourceGroupName
  network_interface_ids = ["${var.network_interface_id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "disk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "nobsdev01"
    admin_username = "azureuser"
    admin_password = "W3lcomeWorld12%)"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

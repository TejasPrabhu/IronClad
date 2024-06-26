terraform {
  required_providers {
    azapi = {
      source = "azure/azapi"
    }
  }
}

resource "azurerm_network_interface" "jump_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.jump_nic.id]
  size                  = var.vm_size
  admin_username        = var.admin_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    name                  = "${var.vm_name}-osdisk"
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }

  admin_ssh_key {
    username = var.admin_username
    public_key = file(var.public_key_path)    
  }

  tags = {
    "environment" = "IronClad"
  }
}

/*
resource "azurerm_virtual_machine_extension" "ansible_extension" {
  count                   = var.install_ansible ? 1 : 0 
  name                    = "install_ansible"
  virtual_machine_id      = azurerm_linux_virtual_machine.vm.id
  publisher               = "Microsoft.Azure.Extensions"
  type                    = "CustomScript"
  type_handler_version    = "2.0"

  protected_settings = <<PROT
  {
      "script": "${base64encode(file(var.ansible_installation_script_path))}"
  }
  PROT

  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}
*/



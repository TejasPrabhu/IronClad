resource "azurerm_resource_group" "ironclad_rg" {
  name     = var.resource_group_name
  location = var.location
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.ironclad_rg.name
  location            = "East US"
  vnet_name           = "ironclad-vnet"
  vnet_address_space  = ["10.0.0.0/16"]
  subnet_private_address_prefixes = ["10.0.1.0/24"]
  subnet_public_address_prefixes  = ["10.0.2.0/24"]
  public_ip           = "0.0.0.0/0"
}

module "jump-vm" {
  source               = "./modules/vm"
  vm_name              = "jump-vm"
  resource_group_name  = azurerm_resource_group.ironclad_rg.name
  resource_group_name_id = azurerm_resource_group.ironclad_rg.id
  location             = var.location
  subnet_id            = module.networking.subnet_public_id
  vm_size              = "Standard_B1s"
  admin_username       = "jumpadmin"
  public_ip_address_id  = azurerm_public_ip.jump_vm_public_ip.id
  public_key_path  = var.public_key_path
  install_ansible = true
  ansible_installation_script_path = var.ansible_installation_script_path
}

resource "null_resource" "jump_vm_provisioner" {
  depends_on = [module.jump-vm]

  provisioner "file" {
    source      = var.private_key_path
    destination = "/home/jumpadmin/.ssh/id_rsa"

    connection {
      type        = "ssh"
      user        = "jumpadmin"
      private_key = file(var.private_key_path)
      host        = azurerm_public_ip.jump_vm_public_ip.ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/jumpadmin/.ssh/id_rsa",
      "mkdir /home/jumpadmin/installation_scripts/"
    ]

    connection {
      type        = "ssh"
      user        = "jumpadmin"
      private_key = file(var.private_key_path)
      host        = azurerm_public_ip.jump_vm_public_ip.ip_address
    }
  }

  provisioner "file" {
    source = "${var.installation_script_path}/"
    destination = "/home/jumpadmin/installation_scripts/"
    connection {
      type        = "ssh"
      user        = "jumpadmin"
      private_key = file(var.private_key_path)
      host        = azurerm_public_ip.jump_vm_public_ip.ip_address
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/jumpadmin/installation_scripts/*.sh",
      "sudo /home/jumpadmin/installation_scripts/install_ansible.sh",
      "ansible-playbook /home/jumpadmin/installation_scripts/install_docker.yml",
      "ansible-playbook /home/jumpadmin/installation_scripts/install_jenkins.yml",
      "ansible-playbook /home/jumpadmin/installation_scripts/deploy_containers.yml"
    ]

    connection {
      type        = "ssh"
      user        = "jumpadmin"
      private_key = file(var.private_key_path)
      host        = azurerm_public_ip.jump_vm_public_ip.ip_address
    }
  }
}

resource "azurerm_public_ip" "jump_vm_public_ip" {
  name                = "jump-vm-public-ip"
  resource_group_name = azurerm_resource_group.ironclad_rg.name
  location            = var.location
  allocation_method   = "Static"
}

module "jenkins-vm" {
  source               = "./modules/vm"
  vm_name              = "jenkins-vm"
  resource_group_name  = azurerm_resource_group.ironclad_rg.name
  resource_group_name_id = azurerm_resource_group.ironclad_rg.id
  location             = var.location
  subnet_id            = module.networking.subnet_private_id
  vm_size              = "Standard_B1s"
  admin_username       = "jenkinsadmin"
  public_key_path  = var.public_key_path
}

module "security-vm" {
  source               = "./modules/vm"
  vm_name              = "security-vm"
  resource_group_name  = azurerm_resource_group.ironclad_rg.name
  resource_group_name_id = azurerm_resource_group.ironclad_rg.id
  location             = var.location
  subnet_id            = module.networking.subnet_private_id
  vm_size              = "Standard_B1ms"
  admin_username       = "securityadmin"
  public_key_path  = var.public_key_path
}

module "monitoring-vm" {
  source               = "./modules/vm"
  vm_name              = "monitoring-vm"
  resource_group_name  = azurerm_resource_group.ironclad_rg.name
  resource_group_name_id = azurerm_resource_group.ironclad_rg.id
  location             = var.location
  subnet_id            = module.networking.subnet_private_id
  vm_size              = "Standard_B1ms"
  admin_username       = "monitoringadmin"
  public_key_path  = var.public_key_path
}
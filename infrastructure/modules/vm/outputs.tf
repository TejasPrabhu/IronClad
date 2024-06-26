output "ssh_public_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).publicKey
}

output "ssh_private_key" {
  value = jsondecode(azapi_resource_action.ssh_public_key_gen.output).privateKey
  sensitive = true
}

output "jump_vm_private_ip_address" {
  value = azurerm_network_interface.jump_nic.private_ip_address
}
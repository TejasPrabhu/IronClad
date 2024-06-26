output "vnet_id" {
  value = azurerm_virtual_network.ironclad_vnet.id
}

output "subnet_private_id" {
  value = azurerm_subnet.ironclad_subnet_private.id
}

output "subnet_public_id" {
  value = azurerm_subnet.ironclad_subnet_public.id
}

output "nsg_private_id" {
  value = azurerm_network_security_group.ironclad_nsg_private.id
}

output "nsg_public_id" {
  value = azurerm_network_security_group.ironclad_nsg_public.id
}

output "nat_gateway_public_ip" {
  value = azurerm_public_ip.nat_gateway_ip.ip_address
}
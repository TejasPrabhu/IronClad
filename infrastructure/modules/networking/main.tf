resource "azurerm_virtual_network" "ironclad_vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "ironclad_subnet_private" {
  name                 = "ironclad-subnet-private"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ironclad_vnet.name
  address_prefixes     = var.subnet_private_address_prefixes
}

resource "azurerm_subnet" "ironclad_subnet_public" {
  name                 = "ironclad-subnet-public"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ironclad_vnet.name
  address_prefixes     = var.subnet_public_address_prefixes
}

resource "azurerm_network_security_group" "ironclad_nsg_private" {
  name                = "ironclad-nsg-private"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = { for rule in var.nsg_rules : rule.name => rule }
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_ranges     = security_rule.value.destination_port_ranges
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_security_group" "ironclad_nsg_public" {
  name                = "ironclad-nsg-public"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "ssh"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "71.69.148.63"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "private" {
  subnet_id                 = azurerm_subnet.ironclad_subnet_private.id
  network_security_group_id = azurerm_network_security_group.ironclad_nsg_private.id
}

resource "azurerm_subnet_network_security_group_association" "public" {
  subnet_id                 = azurerm_subnet.ironclad_subnet_public.id
  network_security_group_id = azurerm_network_security_group.ironclad_nsg_public.id
}


resource "azurerm_public_ip" "nat_gateway_ip" {
  name                = "nat-gateway-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "ironclad_nat_gateway" {
  name                = "ironclad-nat-gateway"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  nat_gateway_id       = azurerm_nat_gateway.ironclad_nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_gateway_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  subnet_id      = azurerm_subnet.ironclad_subnet_private.id
  nat_gateway_id = azurerm_nat_gateway.ironclad_nat_gateway.id
}

variable "public_ip" {
  description = "Your public IP address for secure access"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the resources"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet"
  type        = list(string)
}

variable "subnet_private_address_prefixes" {
  description = "Address prefix for the private subnet"
  type        = list(string)
}

variable "subnet_public_address_prefixes" {
  description = "Address prefix for the public subnet"
  type        = list(string)
}

variable "nsg_rules" {
  description = "List of NSG rules"
  type = list(object({
    name                    = string
    priority                = number
    direction               = string
    access                  = string
    protocol                = string
    source_port_range      = string
    destination_port_ranges = list(string)
    source_address_prefix   = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                    = "SMTP"
      priority                = 100
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["25"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "CustomTCP3000-10000"
      priority                = 110
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["3000-10000"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "HTTP"
      priority                = 120
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["80"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "HTTPS"
      priority                = 130
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["443"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "SSH"
      priority                = 140
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["22"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "CustomTCP"
      priority                = 150
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["6443"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "SMTPS"
      priority                = 160
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["465"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    },
    {
      name                    = "CustomTCP30000-32767"
      priority                = 170
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range      = "*"
      destination_port_ranges = ["30000-32767"]
      source_address_prefix   = "0.0.0.0/0"
      destination_address_prefix = "*"
    }
  ]
}

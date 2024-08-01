variable "resource_group_name" {
  type    = string
  description = "Name of the resource group"
  default     = "ironclad_rg"
}

variable "location" {
  type    = string
  description = "Azure location for all resources"
  default     = "East US"
}

variable "public_key_path" {
  description = "Path to the SSH public key file."
  type = string
}

variable "private_key_path" {
  description = "Path to the SSH private key file."
  type = string
  sensitive = true
}

variable "ansible_installation_script_path" {
  description = "The path for ansible installation path"
  type        = string
}

variable "installation_script_path" {
  description = "The path for installation scripts"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual machine."
  type        = string
}

variable "resource_group_name_id" {
  description = "The id of the resource group in which to create the virtual machine."
  type        = string
}

variable "location" {
  description = "The location/region in which to create the virtual machine."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which the network interface will be created."
  type        = string
}

variable "public_ip_address_id" {
  description = "The ID of the public IP address to associate with the network interface, if applicable."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "The size of the virtual machine to create."
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine to create."
  type        = string
}

variable "admin_username" {
  description = "The admin username of the virtual machine."
  type        = string
}

variable "public_key_path" {
  description = "The path for public key for ssh"
  type        = string
}

variable "install_ansible" {
  description = "Whether to install Ansible on this VM."
  type        = bool
  default     = false
}

variable "ansible_installation_script_path" {
  type = string
  default = ""   
}
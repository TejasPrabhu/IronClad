resource "random_pet" "ssh_key_name" {
  prefix    = "ssh"
  separator = ""
}

resource "azapi_resource" "ssh_public_key" {
  type      = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  name      = random_pet.ssh_key_name.id
  location  = var.location
  parent_id = var.resource_group_name_id
}

resource "azapi_resource_action" "ssh_public_key_gen" {
  type        = "Microsoft.Compute/sshPublicKeys@2022-11-01"
  resource_id = azapi_resource.ssh_public_key.id
  action      = "generateKeyPair"
  method      = "POST"

  response_export_values = ["publicKey", "privateKey"]
}

locals {
  decoded_output = jsondecode(azapi_resource_action.ssh_public_key_gen.output)
}

resource "local_file" "public_key" {
  content  = local.decoded_output.publicKey
  filename = "public_key.pub"
}

resource "local_file" "private_key" {
  content  = local.decoded_output.privateKey
  filename = "private_key"
}
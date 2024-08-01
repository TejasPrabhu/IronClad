resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "ironclad-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "ironclad"

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}
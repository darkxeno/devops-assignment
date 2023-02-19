resource "azurerm_container_registry" "acr" {
  name                = "cordaACR"
  resource_group_name = var.azurerm_resource_group.name
  location            = var.azurerm_resource_group.location
  sku                 = "Premium"
}

resource "azurerm_kubernetes_cluster" "corda-cluster" {
  name                = "corda-aks-cluster"
  location            = var.azurerm_resource_group.location
  resource_group_name = var.azurerm_resource_group.name
  dns_prefix          = "cordaaks1"

  // normally the next line should be mandatory
  #private_cluster_enabled = true

  default_node_pool {
    name           = "cordanodes"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    //vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "DEV"
  }
}

resource "azurerm_role_assignment" "ecr-from-aks-role" {
  principal_id                     = azurerm_kubernetes_cluster.corda-cluster.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}

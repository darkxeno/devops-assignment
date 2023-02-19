
output "kube_config"{
  value     = azurerm_kubernetes_cluster.corda-cluster.kube_config.0
  sensitive = true
}

output "kube_config_raw" {
  value = azurerm_kubernetes_cluster.corda-cluster.kube_config_raw
  sensitive = true
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "default_node_pool" {
  value = azurerm_kubernetes_cluster.corda-cluster.default_node_pool[0]
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.corda-cluster.name
}

output "node_resource_group" {
  value = azurerm_kubernetes_cluster.corda-cluster.node_resource_group
}

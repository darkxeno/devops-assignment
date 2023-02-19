
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
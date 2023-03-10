
output "admin_password" {
  value     = random_password.admin_password.result
  sensitive = true
}

output "database_server_name" {
  value     = azurerm_postgresql_server.postgres.name
}

output "database_schema_name" {
  value     = azurerm_postgresql_database.corda.name
}

output "database_user" {
  value     = local.database_user
}

output "database_fqdn" {
  value     = azurerm_postgresql_server.postgres.fqdn
}

output "database_private_ip" {
  value     = azurerm_private_endpoint.private-endpoint.private_service_connection[0].private_ip_address
}

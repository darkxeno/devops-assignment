


locals {
  database_user = "psqladmin"
}

resource "random_password" "admin_password" {
  length           = 20
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_server" "postgres" {
  name                = "corda-postgres"
  location            = var.azurerm_resource_group.location
  resource_group_name = var.azurerm_resource_group.name

  administrator_login          = local.database_user
  administrator_login_password = random_password.admin_password.result

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 5120

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}

data "azurerm_kubernetes_cluster_node_pool" "aks-node-pool" {
  name                    = var.aks_node_group_name
  kubernetes_cluster_name = var.aks_cluster_name
  resource_group_name     = var.azurerm_resource_group.name
}

data "azurerm_subnet" "aks-subnet" {
  name                 = "aks-subnet"
  virtual_network_name = "aks-vnet-36513379"
  resource_group_name  = var.node_resource_group
}

resource "azurerm_private_endpoint" "private-endpoint" {
  name                = "postgres-private-endpoint"
  location            = var.azurerm_resource_group.location
  resource_group_name = var.azurerm_resource_group.name
  //subnet_id           = var.vnet_subnet_id
  subnet_id           = data.azurerm_subnet.aks-subnet.id

  private_service_connection {
    name                           = "postgres-privateserviceconnection"
    private_connection_resource_id = azurerm_postgresql_server.postgres.id
    subresource_names              = [ "postgresqlServer" ]
    is_manual_connection           = false
  }
}


resource "azurerm_postgresql_database" "corda" {
  name                = "corda"
  server_name         = azurerm_postgresql_server.postgres.name
  resource_group_name = var.azurerm_resource_group.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

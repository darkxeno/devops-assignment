
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "corda" {
  name     = "corda-resources"
  location = "West Europe"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "corda" {
  name                = "corda-network"
  resource_group_name = azurerm_resource_group.corda.name
  location            = azurerm_resource_group.corda.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "corda-subnet"
  resource_group_name  = azurerm_resource_group.corda.name
  virtual_network_name = azurerm_virtual_network.corda.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

module "secrets-management" {
  source  = "./modules/secrets-management"

  azurerm_resource_group = azurerm_resource_group.corda
}

module "kubernetes-cluster-creation" {
  source  = "./modules/kubernetes-cluster-creation"

  azurerm_resource_group = azurerm_resource_group.corda
  vnet_subnet_id = azurerm_subnet.subnet-1.id
}

module "postgress-database" {
  source = "./modules/postgress-database"

  azurerm_resource_group = azurerm_resource_group.corda
  vnet_subnet_id         = azurerm_subnet.subnet-1.id
  aks_node_group_name    = module.kubernetes-cluster-creation.default_node_pool.name
  aks_cluster_name       = module.kubernetes-cluster-creation.cluster_name
  node_resource_group    = module.kubernetes-cluster-creation.node_resource_group
}

module "helm-chart-deployment" {
  source  = "./modules/helm-chart-deployment"

  kube_config       = module.kubernetes-cluster-creation.kube_config
  database_url      = "jdbc:postgresql://${module.postgress-database.database_private_ip}:5432/${module.postgress-database.database_schema_name}?sslmode=require"
  database_user     = "${module.postgress-database.database_user}@${module.postgress-database.database_server_name}"
  database_password = module.postgress-database.admin_password
  acr_login_server  = module.kubernetes-cluster-creation.acr_login_server

  key_store_password   = module.secrets-management.secret_values["KEY_STORE_PASSWORD"]
  trust_store_password = module.secrets-management.secret_values["TRUST_STORE_PASSWORD"]
}

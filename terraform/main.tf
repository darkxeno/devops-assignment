
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
}

module "postgress-database" {
  source = "./modules/postgress-database"

  azurerm_resource_group = azurerm_resource_group.corda
}


module "kubernetes-cluster-creation" {
  source  = "./modules/kubernetes-cluster-creation"

  azurerm_resource_group = azurerm_resource_group.corda
  vnet_subnet_id = azurerm_subnet.subnet-1.id
}

module "helm-chart-deployment" {
  source  = "./modules/helm-chart-deployment"

  kube_config       = module.kubernetes-cluster-creation.kube_config
  database_password = module.postgress-database.admin_password
  acr_login_server  = module.kubernetes-cluster-creation.acr_login_server
}
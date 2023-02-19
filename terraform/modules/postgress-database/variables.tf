
variable "azurerm_resource_group" {
    description = "Azure Resource Group where to deploy this module"
    type = object({
        location          = string
        name              = string
    })
}

variable "vnet_subnet_id" {
    description = "Vnet where to deploy the cluster nodes"
    type = string
}

variable "aks_node_group_name" {
    description = "Node group that needs to connect to this DB"
    type = string
}

variable "aks_cluster_name" {
    description = "AKS cluster that needs to connect to this DB"
    type = string
}

variable "node_resource_group" {
    description = "Resource group of the AKS cluster"
    type = string
}

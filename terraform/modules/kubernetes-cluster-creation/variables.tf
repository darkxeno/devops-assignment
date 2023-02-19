
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
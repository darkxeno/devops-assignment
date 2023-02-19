
variable "azurerm_resource_group" {
    description = "Azure Resource Group where to deploy this module"
    type = object({
        location          = string
        name              = string
    })
}
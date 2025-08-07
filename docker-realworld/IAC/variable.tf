variable "azurerm_resource_group_name" {
  description = "The name of the Azure Resource Group"
  type        = string
  default     = "test-linux_rg"
}
variable "location" {
  description = "The Azure Region where resources will be created"
  type        = string
  default     = "Central India"

}

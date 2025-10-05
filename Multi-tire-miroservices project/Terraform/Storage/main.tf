resource "azurerm_resource_group" "multicontainerrg" {
  location = var.rglocation
  name     = var.rgname
}

resource "azurerm_storage_account" "terraformsa" {
  location                 = var.rglocation
  name                     = "multitiesterraproject"
  resource_group_name      = var.rgname
  account_replication_type = "GRS"
  account_tier             = "Standard"
  depends_on               = [azurerm_resource_group.multicontainerrg]
}

resource "azurerm_storage_container" "terraform" {
  name                  = "terraform"
  container_access_type = "container"
  storage_account_name  = azurerm_storage_account.terraformsa.name
  depends_on            = [azurerm_storage_account.terraformsa]

}
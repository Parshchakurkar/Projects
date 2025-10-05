data "azurerm_resource_group" "rg" {
  name = "multicontainer-rg"
}

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "multitiercontainerAKS"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "multitiercontainerAKS"
  default_node_pool {
    name       = "default"
    vm_size    = "standard_D2ds_v6"
    node_count = 1
    zones      = ["1"]
  }
  identity {
    type = "SystemAssigned"
  }
  role_based_access_control_enabled = true
  kubernetes_version = "1.30.14"

}

resource "azurerm_container_registry" "microserviceACR" {
  name                = "multitirecontainerACR"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  admin_enabled       = "false"

}

resource "azurerm_role_assignment" "acraksconnection" {
  scope                = azurerm_container_registry.microserviceACR.id
  principal_id         = azurerm_kubernetes_cluster.akscluster.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  depends_on           = [azurerm_container_registry.microserviceACR, azurerm_kubernetes_cluster.akscluster]
}
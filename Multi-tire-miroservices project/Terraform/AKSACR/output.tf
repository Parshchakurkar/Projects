output "ACRName" {
  value = azurerm_container_registry.microserviceACR.name
}

output "AKSName" {
  value = azurerm_kubernetes_cluster.akscluster.name
}
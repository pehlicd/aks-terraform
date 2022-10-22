output "vnet-name" {
  value = azurerm_virtual_network.vnet.name
}

output "vnet-id" {
  value = azurerm_virtual_network.vnet.id
}

output "vnet-subnet-id" {
  value = azurerm_subnet.aks-subnet.id
}

output "location" {
  value = azurerm_resource_group.rg.location
}

output "aks-name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "node-count" {
  value = azurerm_kubernetes_cluster.aks.default_node_pool[0].node_count
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
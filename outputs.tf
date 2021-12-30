output "client_certificate" {
  value = azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config_raw
  sensitive = true
}

provider "azurerm" {
    features {}
  }
  
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.integrations_aks_terraform.kube_config.0.cluster_ca_certificate)
}

resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "integrations_aks_terraform" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = "agentpool"
    node_count = var.node_count
    vm_size    = var.node_size
  }
  
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
            network_plugin      = "azure"
            load_balancer_sku    = "Standard"
  }

  tags = {
    environment = var.environment
    created_by  = "Professor"
  }
}

resource "kubernetes_namespace" "integrations_aks_namespace" {
  metadata {
    annotations = {
      name = "receiptsss"
    }

    labels = {
      mylabel = "receiptss-value"
    }

    name = "receiptss"
  }
  depends_on = [azurerm_kubernetes_cluster.integrations_aks_terraform]
}

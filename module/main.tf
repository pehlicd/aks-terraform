terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.credentials["subscription_id"]
  tenant_id       = var.credentials["tenant_id"]
  client_id       = var.credentials["client_id"]
  client_secret   = var.credentials["client_secret"]
}

resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_network_security_group" "sg" {
  name                = "k8s-security-group"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "k8s-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "aks-subnet" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.1.0/24"]
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.cluster_name

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks-subnet.id
  }

  service_principal {
    client_id     = var.credentials["client_id"]
    client_secret = var.credentials["client_secret"]
  }

  network_profile {
    network_plugin = "azure"
  }
  
  role_based_access_control_enabled = true

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks-system" {
  name                  = "system"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2_v2"
  node_count            = 1
  mode                  = "System"
  vnet_subnet_id        = azurerm_subnet.aks-subnet.id

  tags = {
    Environment = var.environment
  }
}
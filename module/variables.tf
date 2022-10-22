variable "credentials" {
  type = map(string)
  default = {
    subscription_id = ""
    tenant_id       = ""
    client_id       = ""
    client_secret   = ""
  }
  sensitive = true
}

variable "cluster_name" {
  description = "The name of the AKS cluster"
  default     = "aks"
  type        = string
}

variable "environment" {
  description = "values: dev, test, prod (default: test)"
  default     = "test"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster (default: 1)"
  default     = 1
  type        = number
}

variable "location" {
  description = "The location/region where the resources should be created."
  default     = "West Europe"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to create."
  default     = "rg"
  type        = string
}
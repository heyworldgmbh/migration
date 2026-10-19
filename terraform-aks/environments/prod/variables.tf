variable "prefix" {
  type    = string
  default = "aks-demo"
}

variable "environment" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus2"
}

variable "address_space" {
  type = list(string)
}

variable "aks_subnet_prefix" {
  type = list(string)
}

variable "system_node_count" {
  type    = number
  default = 1
}

variable "system_node_vm_size" {
  type    = string
  default = "Standard_D2s_v5"
}

variable "user_node_count" {
  type    = number
  default = 2
}

variable "user_node_vm_size" {
  type    = string
  default = "Standard_D4s_v5"
}

variable "frontdoor_sku" {
  type    = string
  default = "Premium_AzureFrontDoor"
}

variable "origin_host_name" {
  description = "Backend origin for Front Door (e.g. ingress controller public FQDN/IP). Update after deploying workloads."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "keyvault_purge_protection_enabled" {
  description = "Whether Key Vault purge protection is enabled for this environment."
  type        = bool
  default     = true
}

variable "purge_soft_deleted_keyvault_on_destroy" {
  description = "Whether 'terraform destroy' permanently purges the Key Vault instead of leaving it soft-deleted. Only takes effect when keyvault_purge_protection_enabled = false."
  type        = bool
  default     = false
}

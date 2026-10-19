variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "dns_prefix" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "vnet_subnet_id" {
  type = string
}

variable "service_cidr" {
  type    = string
  default = "10.100.0.0/16"
}

variable "dns_service_ip" {
  type    = string
  default = "10.100.0.10"
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "keyvault_id" {
  type = string
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

variable "tags" {
  type    = map(string)
  default = {}
}

variable "name_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  description = "Front Door SKU. Must be Premium_AzureFrontDoor for managed WAF rule sets (DefaultRuleSet/BotManager)."
  type        = string
  default     = "Premium_AzureFrontDoor"
}

variable "origin_host_name" {
  description = "FQDN or IP of the backend origin (e.g. the AKS ingress controller's public endpoint)"
  type        = string
}

variable "origin_host_header" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

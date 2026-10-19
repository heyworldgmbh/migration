variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "sku_name" {
  type    = string
  default = "standard"
}

variable "allowed_subnet_ids" {
  description = "Subnet IDs allowed to reach the Key Vault via service endpoint"
  type        = list(string)
  default     = []
}

variable "purge_protection_enabled" {
  description = "Whether purge protection is enabled. Leave true for durable environments; set false for ephemeral ones that need to be destroyed and recreated under the same name without waiting out the soft-delete retention period."
  type        = bool
  default     = true
}

variable "tags" {
  type    = map(string)
  default = {}
}

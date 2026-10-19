variable "name_prefix" {
  description = "Lowercase alphanumeric prefix used in the globally-unique storage account name"
  type        = string
  default     = "aksdemo"
}

variable "resource_group_name" {
  type    = string
  default = "rg-aks-demo-tfstate"
}

variable "location" {
  type    = string
  default = "eastus2"
}

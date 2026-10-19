variable "name_prefix" {
  description = "Prefix used to name networking resources"
  type        = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "aks_subnet_prefix" {
  description = "Address prefixes for the AKS subnet"
  type        = list(string)
}

variable "tags" {
  type    = map(string)
  default = {}
}

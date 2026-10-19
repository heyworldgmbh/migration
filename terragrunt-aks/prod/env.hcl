locals {
  environment         = "prod"
  location            = "eastus2"
  prefix              = "aks-demo"
  unique_suffix       = "p1"
  address_space       = ["10.30.0.0/16"]
  aks_subnet_prefix   = ["10.30.1.0/24"]
  system_node_count   = 2
  system_node_vm_size = "Standard_D4s_v5"
  user_node_count     = 3
  user_node_vm_size   = "Standard_D8s_v5"
  frontdoor_sku       = "Premium_AzureFrontDoor"
  origin_host_name    = "placeholder.example.com"

  keyvault_purge_protection_enabled      = true
  purge_soft_deleted_keyvault_on_destroy = false

  tags = {
    environment = "prod"
    managed_by  = "terragrunt"
    project     = "aks-demo"
  }
}

locals {
  environment         = "dev"
  location            = "eastus2"
  prefix              = "aks-demo"
  unique_suffix       = "d1"
  address_space       = ["10.10.0.0/16"]
  aks_subnet_prefix   = ["10.10.1.0/24"]
  system_node_count   = 1
  system_node_vm_size = "Standard_D2s_v5"
  user_node_count     = 2
  user_node_vm_size   = "Standard_D4s_v5"
  frontdoor_sku       = "Premium_AzureFrontDoor"
  origin_host_name    = "placeholder.example.com"

  keyvault_purge_protection_enabled      = true
  purge_soft_deleted_keyvault_on_destroy = false

  tags = {
    environment = "dev"
    managed_by  = "terragrunt"
    project     = "aks-demo"
  }
}

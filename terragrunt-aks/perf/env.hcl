locals {
  environment         = "perf"
  location            = "eastus2"
  prefix              = "aks-demo"
  unique_suffix       = "pf1"
  address_space       = ["10.40.0.0/16"]
  aks_subnet_prefix   = ["10.40.1.0/24"]
  system_node_count   = 1
  system_node_vm_size = "Standard_D2s_v5"
  user_node_count     = 3
  user_node_vm_size   = "Standard_D4s_v5"
  frontdoor_sku       = "Premium_AzureFrontDoor"
  origin_host_name    = "placeholder.example.com"

  # Ephemeral environment: allow Key Vault to be fully purged on destroy so
  # it can be recreated under the same name the next time this is spun up.
  keyvault_purge_protection_enabled      = false
  purge_soft_deleted_keyvault_on_destroy = true

  tags = {
    environment = "perf"
    managed_by  = "terragrunt"
    project     = "aks-demo"
    ephemeral   = "true"
  }
}

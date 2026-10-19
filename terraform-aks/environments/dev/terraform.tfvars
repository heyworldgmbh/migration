environment         = "dev"
location            = "eastus2"
address_space       = ["10.10.0.0/16"]
aks_subnet_prefix   = ["10.10.1.0/24"]
system_node_count   = 1
system_node_vm_size = "Standard_D2s_v5"
user_node_count     = 2
user_node_vm_size   = "Standard_D4s_v5"
frontdoor_sku       = "Premium_AzureFrontDoor"
origin_host_name    = "placeholder.example.com"

tags = {
  environment = "dev"
  managed_by  = "terraform"
  project     = "aks-demo"
}

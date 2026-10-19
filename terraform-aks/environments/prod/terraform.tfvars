environment         = "prod"
location            = "eastus2"
address_space       = ["10.30.0.0/16"]
aks_subnet_prefix   = ["10.30.1.0/24"]
system_node_count   = 2
system_node_vm_size = "Standard_D4s_v5"
user_node_count     = 3
user_node_vm_size   = "Standard_D8s_v5"
frontdoor_sku       = "Premium_AzureFrontDoor"
origin_host_name    = "placeholder.example.com"

tags = {
  environment = "prod"
  managed_by  = "terraform"
  project     = "aks-demo"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

module "resource_group" {
  source = "../../modules/resource-group"

  name     = "rg-${var.prefix}-${var.environment}"
  location = var.location
  tags     = var.tags
}

module "networking" {
  source = "../../modules/networking"

  name_prefix         = "${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.name
  address_space       = var.address_space
  aks_subnet_prefix   = var.aks_subnet_prefix
  tags                = var.tags
}

module "log_analytics" {
  source = "../../modules/log-analytics"

  name                = "log-${var.prefix}-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  name                     = "kv-${var.prefix}-${var.environment}-${random_string.suffix.result}"
  location                 = var.location
  resource_group_name      = module.resource_group.name
  allowed_subnet_ids       = [module.networking.aks_subnet_id]
  purge_protection_enabled = var.keyvault_purge_protection_enabled
  tags                     = var.tags
}

module "acr" {
  source = "../../modules/acr"

  name                = "acr${replace(var.prefix, "-", "")}${var.environment}${random_string.suffix.result}"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

module "aks" {
  source = "../../modules/aks"

  name                       = "aks-${var.prefix}-${var.environment}"
  location                   = var.location
  resource_group_name        = module.resource_group.name
  dns_prefix                 = "${var.prefix}-${var.environment}"
  vnet_subnet_id             = module.networking.aks_subnet_id
  log_analytics_workspace_id = module.log_analytics.id
  acr_id                     = module.acr.id
  keyvault_id                = module.keyvault.id
  system_node_count          = var.system_node_count
  system_node_vm_size        = var.system_node_vm_size
  user_node_count            = var.user_node_count
  user_node_vm_size          = var.user_node_vm_size
  tags                       = var.tags
}

module "frontdoor" {
  source = "../../modules/frontdoor"

  name_prefix         = "${var.prefix}-${var.environment}"
  resource_group_name = module.resource_group.name
  sku_name            = var.frontdoor_sku
  origin_host_name    = var.origin_host_name
  tags                = var.tags
}

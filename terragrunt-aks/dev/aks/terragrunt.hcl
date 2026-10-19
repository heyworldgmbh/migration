include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../modules/aks"
}

dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs                            = { name = "mock-rg" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "networking" {
  config_path = "../networking"

  mock_outputs                            = { aks_subnet_id = "mock-subnet-id" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "log_analytics" {
  config_path = "../log-analytics"

  mock_outputs                            = { id = "mock-law-id" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "acr" {
  config_path = "../acr"

  mock_outputs                            = { id = "mock-acr-id" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

dependency "keyvault" {
  config_path = "../keyvault"

  mock_outputs                            = { id = "mock-kv-id" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name                        = "aks-${local.env.prefix}-${local.env.environment}"
  location                    = local.env.location
  resource_group_name         = dependency.resource_group.outputs.name
  dns_prefix                  = "${local.env.prefix}-${local.env.environment}"
  vnet_subnet_id              = dependency.networking.outputs.aks_subnet_id
  log_analytics_workspace_id  = dependency.log_analytics.outputs.id
  acr_id                      = dependency.acr.outputs.id
  keyvault_id                 = dependency.keyvault.outputs.id
  system_node_count           = local.env.system_node_count
  system_node_vm_size         = local.env.system_node_vm_size
  user_node_count             = local.env.user_node_count
  user_node_vm_size           = local.env.user_node_vm_size
  tags                        = local.env.tags
}

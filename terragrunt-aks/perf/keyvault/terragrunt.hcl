include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../modules/keyvault"
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

inputs = {
  name                = "kv-${local.env.prefix}-${local.env.environment}-${local.env.unique_suffix}"
  location            = local.env.location
  resource_group_name       = dependency.resource_group.outputs.name
  allowed_subnet_ids        = [dependency.networking.outputs.aks_subnet_id]
  purge_protection_enabled  = local.env.keyvault_purge_protection_enabled
  tags                      = local.env.tags
}

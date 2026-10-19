include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../modules/log-analytics"
}

dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs                            = { name = "mock-rg" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name                = "log-${local.env.prefix}-${local.env.environment}"
  location            = local.env.location
  resource_group_name = dependency.resource_group.outputs.name
  tags                = local.env.tags
}

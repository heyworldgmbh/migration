include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../modules/acr"
}

dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs                            = { name = "mock-rg" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name                = "acr${replace(local.env.prefix, "-", "")}${local.env.environment}${local.env.unique_suffix}"
  location            = local.env.location
  resource_group_name = dependency.resource_group.outputs.name
  tags                = local.env.tags
}

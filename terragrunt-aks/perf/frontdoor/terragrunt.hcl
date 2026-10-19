include "root" {
  path = find_in_parent_folders()
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../modules/frontdoor"
}

dependency "resource_group" {
  config_path = "../resource-group"

  mock_outputs                            = { name = "mock-rg" }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "init"]
}

inputs = {
  name_prefix         = "${local.env.prefix}-${local.env.environment}"
  resource_group_name = dependency.resource_group.outputs.name
  sku_name            = local.env.frontdoor_sku
  origin_host_name    = local.env.origin_host_name
  tags                = local.env.tags
}

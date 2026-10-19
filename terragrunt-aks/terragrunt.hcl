locals {
  tfstate_resource_group  = get_env("TFSTATE_RESOURCE_GROUP", "rg-aks-demo-tfstate")
  tfstate_storage_account = get_env("TFSTATE_STORAGE_ACCOUNT_NAME", "stchangeme")
  tfstate_container       = "tfstate"

  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

remote_state {
  backend = "azurerm"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    resource_group_name  = local.tfstate_resource_group
    storage_account_name = local.tfstate_storage_account
    container_name       = local.tfstate_container
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "azurerm" {
      features {
        key_vault {
          purge_soft_delete_on_destroy    = ${local.env_vars.purge_soft_deleted_keyvault_on_destroy}
          recover_soft_deleted_key_vaults = true
        }
      }
    }
  EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_version = ">= 1.7.0"
      required_providers {
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "~> 4.0"
        }
      }
    }
  EOF
}

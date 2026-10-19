# terraform-aks

Plain Terraform project that stands up an AKS cluster on Azure with:

- Resource group
- Virtual network + AKS subnet (with service endpoints for Key Vault/ACR/Storage) + NSG
- Log Analytics workspace (Container Insights via the AKS `oms_agent` add-on)
- Azure Container Registry, with `AcrPull` granted to the AKS kubelet identity
- Key Vault (RBAC-authorized, network-restricted to the AKS subnet), with the AKS
  Key Vault Secrets Provider add-on granted `Key Vault Secrets User`
- AKS cluster (Azure CNI, Azure RBAC, workload identity + OIDC issuer enabled,
  separate system/user node pools)
- Azure Front Door (Premium) with a WAF policy (Default Rule Set + Bot Manager,
  Prevention mode) in front of a configurable origin

Four environments are provided: `dev`, `stage`, `prod`, `perf`. Each is an
independent root module under `environments/<env>` that wires the modules in
`modules/` together; nothing is shared automatically between environments.

The sibling `terragrunt-aks` project deploys the same infrastructure (it
vendors its own copy of these modules) using Terragrunt instead, to show what
Terragrunt buys you over plain Terraform: a DRY backend/provider config, one
value file per environment instead of duplicated root modules, and explicit
`dependency` wiring between per-resource state files. The two projects are
otherwise independent — neither reads from the other at runtime.

## Layout

```
modules/            reusable building blocks (one Azure capability each)
environments/       one deployable stack per environment
bootstrap/          one-time setup of the remote state storage account
```

## Usage

### 1. Bootstrap remote state (once)

```sh
cd bootstrap
terraform init
terraform apply
terraform output storage_account_name
```

This creates a resource group + storage account + container to hold Terraform
state for all three environments (each environment uses its own state file
key inside the same container).

### 2. Deploy an environment

```sh
cd environments/dev
cp backend.hcl.example backend.hcl
# edit backend.hcl: set storage_account_name to the bootstrap output

terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Repeat for `stage` and `prod`.

### `perf`: spin up / spin down

`perf` is meant to be created for a load test and destroyed afterwards, not
left running. Same commands as any other environment:

```sh
cd environments/perf
cp backend.hcl.example backend.hcl   # edit storage_account_name
terraform init -backend-config=backend.hcl
terraform apply -var-file=terraform.tfvars
# ... run your load test ...
terraform destroy -var-file=terraform.tfvars
```

Repeating that `apply`/`destroy` cycle under the same resource names works
cleanly because `perf/terraform.tfvars` sets:

```hcl
keyvault_purge_protection_enabled      = false
purge_soft_deleted_keyvault_on_destroy = true
```

By default, Key Vault purge protection is **on** (`dev`/`stage`/`prod`), which
is correct for durable environments but would break `perf`: a destroyed vault
stays soft-deleted for `soft_delete_retention_days` (7 days) and purge
protection blocks deleting it early, so the next `apply` would fail trying to
create a vault with a name that's still reserved. Disabling purge protection
for `perf` and setting `purge_soft_delete_on_destroy = true` on the provider
means `terraform destroy` actually purges the vault, so the next `apply`
starts clean.

### Front Door origin

`origin_host_name` defaults to a placeholder. Front Door needs a real backend
to route to (typically your ingress controller's public IP/FQDN), which only
exists after you've deployed workloads to the cluster. Update
`origin_host_name` in each environment's `terraform.tfvars` once that's
available and re-apply.

## Requirements

- Terraform >= 1.7
- Authenticated Azure CLI session (`az login`) or equivalent service
  principal credentials for the `azurerm` provider
- Note: `Premium_AzureFrontDoor` is required for managed WAF rule sets;
  the Standard SKU only supports custom WAF rules.

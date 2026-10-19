# terragrunt-aks

Self-contained Terragrunt project that deploys the same AKS infrastructure as
the sibling `terraform-aks` project — resource group, networking, Log
Analytics, Key Vault, ACR, AKS, Front Door + WAF — using its own vendored
copy of the modules (`modules/`) and its own state bootstrap (`bootstrap/`).
Nothing in here reads from or depends on `../terraform-aks` at runtime; it's
meant to be compared side by side with it, not to require it.

Where plain Terraform (`terraform-aks`) duplicates config per environment,
Terragrunt DRYs it up:

- One root `terragrunt.hcl` generates the `azurerm` backend block and the
  provider/version blocks for every component — defined once, not copy-pasted
  per environment.
- One `env.hcl` per environment holds every environment-specific value
  (region, address space, node sizes, tags, ...). Components read it instead
  of redeclaring variables.
- Explicit `dependency` blocks wire module outputs (e.g. the AKS subnet ID,
  the ACR ID) into downstream components and let `terragrunt run --all`
  compute the correct apply order automatically.
- Each Azure resource gets its own Terraform state file
  (`<env>/<component>/terraform.tfstate`), instead of one large root module
  state per environment.

## Layout

```
terragrunt.hcl         root config: remote state + provider/version generation
modules/                vendored copy of the terraform-aks modules
bootstrap/              one-time setup of this project's own remote state storage account
dev/env.hcl             environment-specific values for dev
dev/<component>/        one terragrunt.hcl per Azure resource, per environment
stage/...
prod/...
perf/...               ephemeral load-testing environment, see below
```

Components, in dependency order: `resource-group`, `networking`,
`log-analytics`, `keyvault`, `acr`, `aks`, `frontdoor`.

## Usage

### 1. Bootstrap remote state (once)

```sh
cd bootstrap
terraform init
terraform apply
terraform output storage_account_name
```

Then export the result so the root `terragrunt.hcl` can find it:

```sh
export TFSTATE_RESOURCE_GROUP=rg-aks-demo-tfstate
export TFSTATE_STORAGE_ACCOUNT_NAME=<bootstrap output: storage_account_name>
```

### 2. Deploy an environment

```sh
cd dev
terragrunt run --all -- apply
```

Terragrunt resolves the `dependency` graph and applies components in the
correct order (`resource-group` → `networking`/`log-analytics`/`acr` →
`keyvault` → `aks`/`frontdoor`). Repeat inside `stage/`, `prod/`, or `perf/`.

To operate on a single component (e.g. just scale node pools):

```sh
cd dev/aks
terragrunt apply
```

### `perf`: spin up / spin down

`perf` is meant to be created for a load test and torn down afterwards:

```sh
cd perf
terragrunt run --all -- apply
# ... run your load test ...
terragrunt run --all -- destroy
```

Repeating that cycle under the same resource names works cleanly because
`perf/env.hcl` sets:

```hcl
keyvault_purge_protection_enabled      = false
purge_soft_deleted_keyvault_on_destroy = true
```

`dev`/`stage`/`prod` leave Key Vault purge protection **on**, which is correct
for durable environments but would break a tear-down/recreate cycle: a
destroyed vault stays soft-deleted for 7 days and purge protection blocks
deleting it early, so the next `apply` would fail trying to create a vault
under a name that's still reserved. The root `terragrunt.hcl` reads
`purge_soft_deleted_keyvault_on_destroy` out of whichever `env.hcl` is calling
it and bakes it into the generated provider block — same mechanism that
generates the backend/provider config for every other environment, just
reading a different value for `perf`. That's one `generate` block doing
double duty instead of a one-off override.

### Front Door origin

`origin_host_name` in each `env.hcl` is a placeholder. Point it at your
ingress controller's public endpoint once workloads are deployed, then
re-apply `dev/frontdoor` (or the whole stack).

## Requirements

- Terraform >= 1.7
- Terragrunt >= 1.1
- Authenticated Azure CLI session (`az login`) or equivalent service
  principal credentials
- Note: `Premium_AzureFrontDoor` is required for managed WAF rule sets;
  the Standard SKU only supports custom WAF rules.

## Keeping modules in sync with terraform-aks

`modules/` here is a deliberate copy of `../terraform-aks/modules`, not a
shared reference — that's what makes this project standalone. If you change
one, mirror the change in the other (or fork them further once they no
longer need to stay comparable).

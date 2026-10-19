output "aks_cluster_name" {
  value = module.aks.name
}

output "aks_node_resource_group" {
  value = module.aks.node_resource_group
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "keyvault_uri" {
  value = module.keyvault.uri
}

output "frontdoor_endpoint_hostname" {
  value = module.frontdoor.endpoint_hostname
}

#tests
output "network_domains" {
  value = local.network_domain_list
}

output "connection_policies" {
  value = local.unique_connection_policies
}

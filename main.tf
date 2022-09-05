resource "aviatrix_segmentation_network_domain" "default" {
  for_each = var.manage_network_domains ? toset(local.network_domain_list) : []

  domain_name = each.value
}

resource "aviatrix_segmentation_network_domain_connection_policy" "default" {
  for_each = local.connection_policies_object

  domain_name_1 = each.value[0]
  domain_name_2 = each.value[1]

  depends_on = [
    aviatrix_segmentation_network_domain.default
  ]
}

resource "aviatrix_segmentation_network_domain_association" "default" {
  for_each = var.associations

  transit_gateway_name = each.value.transit_gw
  network_domain_name  = each.value.network_domain
  attachment_name      = each.key

  depends_on = [
    aviatrix_segmentation_network_domain.default
  ]
}

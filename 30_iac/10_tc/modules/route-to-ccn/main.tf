resource "tencentcloud_route_table_entry" "default_ccn_route" {
  route_table_id          = var.route_table_id
  destination_cidr_block  = var.destination_cidr
  next_type               = "USER_CCN"
  next_hub                = var.ccn_id

  description             = var.description
}


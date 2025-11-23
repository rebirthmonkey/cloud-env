resource "tencentcloud_route_table_entry" "default_nat_route" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  next_type              = "NAT"
  next_hub               = var.nat_gateway_id
  description            = var.description
}


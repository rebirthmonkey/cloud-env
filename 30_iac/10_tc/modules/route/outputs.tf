output "route_entry_id" {
  description = "ID of the default route to NAT"
  value       = tencentcloud_route_table_entry.default_nat_route.id
}

output "route_table_id" {
  value = tencentcloud_route_table_entry.default_nat_route.route_table_id
}

output "route_item_id" {
  value = tencentcloud_route_table_entry.default_nat_route.route_item_id
}

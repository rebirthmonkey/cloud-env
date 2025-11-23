output "this_nat_gateway_id" {
  value = tencentcloud_nat_gateway.nat.*.id
}


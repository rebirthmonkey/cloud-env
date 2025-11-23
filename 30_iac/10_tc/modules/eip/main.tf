locals {
  eips = {for k, eip in var.eips: k => eip if try(eip.create_eip, true)}
}

resource "tencentcloud_eip" "eips" {
  for_each = local.eips
  name = try(each.value.name, each.key)
  internet_charge_type       = try(each.value.bandwidth_package_id, null) == null || try(each.value.bandwidth_package_id, null) == "" ? try(each.value.internet_charge_type, "TRAFFIC_POSTPAID_BY_HOUR") : "BANDWIDTH_PACKAGE"
  internet_max_bandwidth_out = try(each.value.internet_max_bandwidth_out, 100)
  type                       = try(each.value.type, "EIP")
  internet_service_provider = try(each.value.internet_service_provider, "BGP")
  bandwidth_package_id = try(each.value.bandwidth_package_id, null) == "" ? null : try(each.value.bandwidth_package_id, null)
  tags = try(each.value.tags, var.tags)
}

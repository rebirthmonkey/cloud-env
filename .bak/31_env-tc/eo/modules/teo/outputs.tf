#output "available_plans" {
#  value = [for plan in data.tencentcloud_teo_zone_available_plans.zoneAvailablePlans.plan_info_list : plan.plan_type]
#}
output "zone_id" {
  value = local.zone_id
}

output "verify_result" {
  value = concat(tencentcloud_teo_ownership_verify.ownership_verify.*.result, [""])[0]
}
output "verify_status" {
  value = concat(tencentcloud_teo_ownership_verify.ownership_verify.*.status, [""])[0]
}
output "cnames" {
  value = {for k, domain in tencentcloud_teo_acceleration_domain.acceleration_domain: domain.domain_name => domain.cname}
}

output "origin_ids" {
  value = local.origin_ids
}

output "l4_domains" {
  value = {for k, l4 in tencentcloud_teo_l4_proxy.proxies: k => l4}
}
output "id" {
  value = local.private_dns_zone_id
}
//output "domain" {
//  value = concat(tencentcloud_private_dns_zone.foo.*.domain, [""])[0]
//}

output "records" {
  value = var.records
}

output "readable_records" {
  value = { for k, record in var.records: k => {
    domain: format("%s.%s", try(record.sub_domain, k), var.domain)
    address: record.record_value
  }}
}

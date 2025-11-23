output "domain_record_id" {
  value       = tencentcloud_dnspod_record.record.*.id
  description = "domain record id"
}

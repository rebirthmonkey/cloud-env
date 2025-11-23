resource "tencentcloud_dnspod_record" "record" {
  domain      = var.domain
  record_type = var.record_type
  record_line  = "默认"
  value       = var.value
  sub_domain  = var.sub_domain
}

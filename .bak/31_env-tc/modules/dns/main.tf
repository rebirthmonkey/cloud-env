resource "random_string" "randomname" {
  count = var.random_domain ? 1: 0
  length  = 16
  special = false
  upper   = false
}

locals {
  domain = var.random_domain ? format("%s.cn", concat(random_string.randomname.*.id, [""])[0]) : var.domain
  records = { for k, record in var.records: k => record if try(record.create, true) && var.do_resolve }
}

resource "tencentcloud_dnspod_domain_instance" "foo" {
  count = var.create_domain ? 1 : 0
  domain = local.domain
  remark = var.remark
}

resource "tencentcloud_dnspod_record" "records" {
  depends_on = [tencentcloud_dnspod_domain_instance.foo]
  for_each = local.records
  domain      = local.domain
  record_type = try(each.value.record_type, "A")
  record_line = try(each.value.record_line, "默认")
  value       = try(each.value.value, "1.2.3.9")
  sub_domain  = try(each.value.sub_domain, each.key)
  mx = try(each.value.mx, null)
  ttl = try(each.value.ttl, 600)
  weight = try(each.value.weight, 0)
  status = try(each.value.status, "ENABLE")
  remark = "managed by Terraform"
}
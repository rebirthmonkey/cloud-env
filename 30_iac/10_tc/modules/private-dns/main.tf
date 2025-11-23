
locals {
  private_dns_zone_id = var.create_private_dns ? tencentcloud_private_dns_zone.foo[0].id: var.private_dns_zone_id
}

resource "tencentcloud_private_dns_zone" "foo" {
  count = var.create_private_dns ? 1 : 0
  domain = var.domain
  tags = var.tags

  dynamic "vpc_set" {
    for_each = var.vpc_sets
    content {
      region   = vpc_set.value.region
      uniq_vpc_id = vpc_set.value.uniq_vpc_id
    }
  }

  remark             = var.remark
  dns_forward_status = var.dns_forward_status  // Whether to enable subdomain recursive DNS. Valid values: ENABLED, DISABLED. Default value: DISABLED.

  dynamic "account_vpc_set" {
    for_each = var.account_vpc_sets
    content {
      uin         = account_vpc_set.value.uin
      region      = account_vpc_set.value.region
      uniq_vpc_id = account_vpc_set.value.uniq_vpc_id
      vpc_name    = account_vpc_set.value.vpc_name
    }
  }
}

resource "tencentcloud_private_dns_record" "records" {
  for_each = var.records
  zone_id      = local.private_dns_zone_id
  record_type  = try(each.value.record_type, "A")
  record_value = try(each.value.record_value, "1.2.3.4")
  sub_domain   = try(each.value.sub_domain, each.key)
  ttl          = try(each.value.ttl, 600)
  weight       = try(each.value.weight, 1)
  mx           = try(each.value.mx, null)  // 5, 10, 15, 20, 30, 40, 50.
}

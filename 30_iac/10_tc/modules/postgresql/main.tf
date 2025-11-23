locals {
  az_name_to_id = { for az in data.tencentcloud_availability_zones.az.zones : az.name => az.id }

  instances = {
    for k, instance in var.instances :
    k => instance
    if try(instance.create, true)
  }

  record_intranet_ip = var.create_private_dns_record ? {
    for k, r in data.tencentcloud_postgresql_instances.pg :
    k => r.instance_list[0].private_access_ip
  }.default : var.record_intranet_ip
}

data "tencentcloud_availability_zones" "az" {}

resource "tencentcloud_postgresql_instance" "pg" {
  for_each = local.instances

  name               = each.value.name
  project_id         = try(each.value.project_id, var.project_id)
  availability_zone  = each.value.availability_zone
  vpc_id             = each.value.vpc_id
  subnet_id          = each.value.subnet_id
  charge_type        = try(each.value.charge_type, "POSTPAID_BY_HOUR")
  memory             = each.value.memory
  cpu                = each.value.cpu
  storage            = each.value.storage
  engine_version     = each.value.engine_version
  charset            = try(each.value.charset, "UTF8")
  security_groups    = try(each.value.security_groups, var.security_groups)
  root_user          = each.value.root_user
  root_password      = each.value.root_password
  tags               = try(each.value.tags, var.tags)

  public_access_switch = false
}

data "tencentcloud_postgresql_instances" "pg" {
  for_each = local.instances

  name = tencentcloud_postgresql_instance.pg[each.key].name
}

resource "tencentcloud_private_dns_record" "records" {
  for_each = var.records

  zone_id      = try(each.value.private_dns_id)
  record_type  = try(each.value.record_type, "A")
  record_value = local.record_intranet_ip
  sub_domain   = try(each.value.sub_domain, each.key)
  ttl          = try(each.value.ttl, 600)
  weight       = try(each.value.weight, 1)
  mx           = try(each.value.mx, null)
}


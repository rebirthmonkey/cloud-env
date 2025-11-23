locals {
  az_name_to_id = { for az in data.tencentcloud_availability_zones.az.zones : az.name => az.id }

  replica_zone_ids = { for k, instance in var.instances: k => [
    for zone_name in try(instance.replica_zone_names, []): lookup(local.az_name_to_id, zone_name, 0)
  ]}
  instances = {for k, instance in var.instances: k => instance if try(instance.create, true)}
  record_intranet_ip = var.create_private_dns_record ? { for k, r in data.tencentcloud_redis_instances.redis: k => r.instance_list[0].ip }.default: var.record_intranet_ip
}

data "tencentcloud_availability_zones" "az" {
}

resource "random_password" "pwd" {
  for_each = local.instances
  length           = 16
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "!#$%&*()-_=+[]<>:?"
}

resource "tencentcloud_redis_instance" "redis" {
  for_each = local.instances
  name               = each.value.name
  type_id            = try(each.value.type_id, 15)
  redis_shard_num    = try(each.value.redis_shard_num, 1)
  redis_replicas_num = try(each.value.replica_zone_names, null) == null ? 0 : length(each.value.replica_zone_names)
  vpc_id             = try(var.vpc_ids[try(each.value.vpc_key, "vpc")], var.vpc_id)
  subnet_id          = try(var.subnet_ids[each.value.subnet_name][each.value.availability_zone], var.subnet_id)
  availability_zone  = each.value.availability_zone
  port               = try(each.value.port, 6379)
  mem_size           = try(each.value.mem_size, 4096)
  charge_type        = try(each.value.charge_type, "POSTPAID")
  auto_renew_flag = try(each.value.charge_type, "POSTPAID") == "PREPAID" ? try(each.value.auto_renew_flag, 1) : null
  prepaid_period = try(each.value.charge_type, "POSTPAID") == "PREPAID" ? try(each.value.prepaid_period, 1) : null
  no_auth            = try(each.value.no_auth, false)
  password           = try(each.value.no_auth, false) ? null : (try(each.value.password, null) == null ? random_password.pwd[each.key].result: each.value.password)
  security_groups    = try(each.value.security_groups, null)
  project_id         = try(each.value.project_id, 0)
  tags               = try(each.value.tags, var.tags)
  replica_zone_ids = local.replica_zone_ids[each.key]
  force_delete = try(each.value.force_delete, false)

  lifecycle {
    ignore_changes = [
      type_id,
    ]
  }
}

resource "tencentcloud_private_dns_record" "records" {
  for_each = var.records
  zone_id      = try(each.value.private_dns_id)
  record_type  = try(each.value.record_type, "A")
  record_value = local.record_intranet_ip
  sub_domain   = try(each.value.sub_domain, each.key)
  ttl          = try(each.value.ttl, 600)
  weight       = try(each.value.weight, 1)
  mx           = try(each.value.mx, null)  // 5, 10, 15, 20, 30, 40, 50.
}

data "tencentcloud_redis_instances" "redis" {
  for_each = local.instances
  zone               = var.availability_zone
  search_key         = try(tencentcloud_redis_instance.redis[each.key].id, null)
}

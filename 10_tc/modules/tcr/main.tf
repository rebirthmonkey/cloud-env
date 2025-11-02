resource "random_string" "randomname" {
  length  = 10
  special = false
  upper   = false
}

locals {
  name = var.random_tcr_suffix ?  format("%s-%s", var.tcr_name, random_string.randomname.id) : var.tcr_name
}


resource "tencentcloud_tcr_instance" "foo" {
  name                  = local.name
  instance_type         = var.instance_type //"basic"
  open_public_operation = var.open_public_operation //false
  registry_charge_type = var.registry_charge_type
  delete_bucket = var.delete_bucket
  dynamic "security_policy" {
    for_each = var.security_policies
    content {
      cidr_block = security_policy.value.cidr_block
    }
  }
}

resource "tencentcloud_tcr_vpc_attachment" "foo" {
  for_each = var.vpc_attachments
  instance_id = tencentcloud_tcr_instance.foo.id
  vpc_id      = each.value.vpc_id
  subnet_id   = each.value.subnet_id
  enable_public_domain_dns = try(each.value.enable_public_domain_dns, false)
  enable_vpc_domain_dns = try(each.value.enable_vpc_domain_dns, false)
}

resource "tencentcloud_tcr_token" "my_token" {
  instance_id = tencentcloud_tcr_instance.foo.id
  description = "tcr token"
#   lifecycle {
#     ignore_changes = [
#       user_name
#     ]
#   }
}

resource "tencentcloud_tcr_namespace" "namespaces" {
  for_each = var.namespaces
  instance_id    = tencentcloud_tcr_instance.foo.id
  name           = try(each.value.name, each.key)
  is_public      = try(each.value.is_public, false)
  is_auto_scan   = try(each.value.is_auto_scan, false)
  is_prevent_vul = try(each.value.is_prevent_vul, false)
  severity       = try(each.value.severity, "medium")  // Block vulnerability level, currently only supports low, medium, high.
  dynamic "cve_whitelist_items" {
    for_each = try(each.value.cve_whitelist_items, [])
    content {
      cve_id = cve_whitelist_items.value.cve_id
    }
  }
}

resource "tencentcloud_tcr_service_account" "service_accounts" {
#   depends_on = [tencentcloud_tcr_namespace.namespaces]
  for_each = var.service_accounts
  registry_id = tencentcloud_tcr_instance.foo.id
  name        = try(each.value.name, each.key)
  dynamic "permissions" {
    for_each = try(each.value.permissions, [])
    content {
      resource = permissions.value.namespace
      actions  = try(permissions.value.actions , [])   // ["tcr:PushRepository", "tcr:PullRepository"]
    }
  }
  description = try(each.value.description, each.key)
  duration    = try(each.value.duration, 10)
  disable     = try(each.value.disable, false)
  tags = try(each.value.tags, {})
}
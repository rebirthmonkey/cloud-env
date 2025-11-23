terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.0"
    }
  }
}

# 仅创建角色，并把传入的策略名列表绑定到该角色
resource "tencentcloud_cam_role" "this" {
  name        = var.cross_role_name
  description = "Role in Account A for Prometheus to assume target accounts"

  # 信任：按运行载体设置（CVM/TKE）
  document = jsonencode({
    version   = "2.0",
    statement = [
      {
        effect    = "allow",
        action    = "sts:AssumeRole",
        principal = {
          service = [ var.carrier_service ]
        }
      }
    ]
  })
}

# 绑定策略到角色（按策略名称绑定）
resource "tencentcloud_cam_role_policy_attachment_by_name" "attach" {
  for_each    = toset(var.attach_policy_names)
  role_name   = tencentcloud_cam_role.this.name
  policy_name = each.value
}



terraform {
  required_version = ">= 1.5.0"

  required_providers {
    tencentcloud = {
      source  = "tencentcloudstack/tencentcloud"
      version = ">= 1.81.0"
    }
  }
}

# 仅创建一个自定义策略：允许 AssumeRole
# Resource 可先用 "*" 调试；正式建议传入目标 Role 的 ARN 以收敛权限
locals {
  assume_resources = length(var.assume_role_resources) > 0 ? var.assume_role_resources : ["*"]
}

resource "tencentcloud_cam_policy" "this" {
  name        = var.cross_policy_name
  description = "Allow AssumeRole for cross-account Prometheus scraping"
  document    = jsonencode({
    version   = "2.0",
    statement = [
      {
        effect   = "allow",
        action   = [ "sts:AssumeRole" ],
        resource = local.assume_resources
      }
    ]
  })
}


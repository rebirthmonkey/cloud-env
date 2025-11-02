data "tencentcloud_images" "this" {
  os_name = var.image_id == null ? var.os_name : null
  image_type = var.image_id == null ? var.image_type : ["PUBLIC_IMAGE"]
  image_id = var.image_id
  image_name_regex = var.image_id == null ? var.image_name: null
}

resource "tencentcloud_as_scaling_config" "example" {
  configuration_name = var.configuration_name
  image_id           = data.tencentcloud_images.this.images[0].image_id
  instance_types     = var.instance_types // ["SA1.SMALL1"]
  project_id         = var.project_id
  system_disk_type   = var.system_disk_type
  system_disk_size   = var.system_disk_size

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      disk_type = try(data_disk.value.type, "CLOUD_PREMIUM")
      disk_size = try(data_disk.value.size, 50)
      delete_with_instance = var.delete_with_instance
    }
  }

  internet_charge_type       = "TRAFFIC_POSTPAID_BY_HOUR"
  internet_max_bandwidth_out = var.allocate_public_ip ? var.internet_max_bandwidth_out : null
  public_ip_assigned         = var.allocate_public_ip
  password                   = var.password
  enhanced_security_service  = true
  enhanced_monitor_service   = true
  security_group_ids = var.security_group_ids
  user_data                  = base64encode(var.user_data_raw)

  host_name_settings {
    host_name       = var.instance_name
    host_name_style = "UNIQUE"
  }

  instance_tags = var.tags
}

resource "tencentcloud_as_scaling_group" "example" {
  scaling_group_name = var.scaling_group_name
  configuration_id   = tencentcloud_as_scaling_config.example.id
  max_size           = var.as_max_size
  min_size           = var.as_min_size
  desired_capacity   = var.as_desired_capacity
  termination_policies = ["NEWEST_INSTANCE"]
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  project_id = var.project_id

  dynamic forward_balancer_ids {
    for_each = var.forward_balancers
    content {
      load_balancer_id = forward_balancer_ids.value.load_balancer_id
      listener_id      = forward_balancer_ids.value.listener_id
      rule_id          = forward_balancer_ids.value.rule_id

      dynamic target_attribute {
        for_each = forward_balancer_ids.value.target_attributes
        content {
          port   = target_attribute.value.target_port
          weight = 100
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }
}

locals {
  as_policies = { for k, p in var.as_policies: k => p if try(p.create, false)}
}
resource "tencentcloud_as_scaling_policy" "example" {
  for_each = local.as_policies
  scaling_group_id    = tencentcloud_as_scaling_group.example.id
  policy_name         = each.value.policy_name
  adjustment_type     = each.value.adjustment_type // "CHANGE_IN_CAPACITY"
  adjustment_value    = each.value.adjustment_value //1
  comparison_operator = each.value.comparison_operator // "GREATER_THAN"
  metric_name         = each.value.metric_name //"CPU_UTILIZATION"
  threshold           = each.value.threshold // 80
  period              = each.value.period // 300
  continuous_time     = each.value.continuous_time // 10
  statistic           = each.value.statistic // "AVERAGE"
  cooldown            = each.value.cooldown // 360
}
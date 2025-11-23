
locals {
  as_group_id  = var.create ? concat(tencentcloud_as_scaling_group.as_group.*.id, [""])[0] : ""

  as_config_trigger_key = format("%s_%s", var.as_config_id, var.as_config_version)
  as_config_version_map = var.trigger_refresh ? { _ : local.as_config_trigger_key } : {}
}

resource "tencentcloud_as_scaling_group" "as_group" {
  count              = var.create ? 1 : 0
  scaling_group_name = var.scaling_group_name
  configuration_id   = var.as_config_id
  max_size           = var.as_max_size
  min_size           = var.as_min_size
  desired_capacity   = var.as_desired_capacity == 0 ? var.as_min_size : var.as_desired_capacity
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  project_id         = var.project_id

  # policies
  retry_policy                    = var.retry_policy                    # Available values for retry policies. Valid values: IMMEDIATE_RETRY and INCREMENTAL_INTERVALS.
  termination_policies            = var.termination_policies            # default ["OLDEST_INSTANCE"] #  OLDEST_INSTANCE and NEWEST_INSTANCE
  multi_zone_subnet_policy        = var.multi_zone_subnet_policy        # default "EQUALITY" # Valid values: PRIORITY and EQUALITY
  replace_monitor_unhealthy       = var.replace_monitor_unhealthy       # Enables unhealthy instance replacement. If set to true, AS will replace instances that are flagged as unhealthy by Cloud Monitor.
  replace_load_balancer_unhealthy = var.replace_load_balancer_unhealthy # Enable unhealthy instance replacement. If set to true, AS will replace instances that are found unhealthy in the CLB health check.
  health_check_type               = var.health_check_type
  lb_health_check_grace_period    = var.health_check_type == "CLB" ? var.lb_health_check_grace_period : null

  dynamic "forward_balancer_ids" {
    for_each = var.forward_balancers
    content {
      load_balancer_id = forward_balancer_ids.value.load_balancer_id
      listener_id      = forward_balancer_ids.value.listener_id
      rule_id          = try(forward_balancer_ids.value.rule_id, null)

      dynamic "target_attribute" {
        for_each = forward_balancer_ids.value.target_attributes
        content {
          port   = target_attribute.value.target_port
          weight = try(target_attribute.value.weight, 100)
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

  tags = var.tags

}


resource "tencentcloud_as_scaling_group_status" "scaling_group_status" {
  count = var.create ? 1 : 0
  auto_scaling_group_id = local.as_group_id
  enable                = var.enable_auto_scaling
}

locals {
  as_policies = { for k, p in var.as_policies : k => p if try(p.create, false) }
  hooks       = { for k, hook in var.hooks : k => hook if try(hook.create, true) }
}

resource "tencentcloud_as_scaling_policy" "as_policies" {
  for_each            = var.create ? local.as_policies : {}
  scaling_group_id    = local.as_group_id
  policy_name         = each.value.policy_name
  adjustment_type     = each.value.adjustment_type     // "CHANGE_IN_CAPACITY"
  adjustment_value    = each.value.adjustment_value    //1
  comparison_operator = each.value.comparison_operator // "GREATER_THAN"
  metric_name         = each.value.metric_name         //"CPU_UTILIZATION"
  threshold           = each.value.threshold           // 80
  period              = each.value.period              // 300
  continuous_time     = each.value.continuous_time     // 10
  statistic           = each.value.statistic           // "AVERAGE"
  cooldown            = each.value.cooldown            // 360
}

resource "tencentcloud_as_lifecycle_hook" "hooks" {
  for_each                 = var.create ? local.hooks : {}
  scaling_group_id         = local.as_group_id
  lifecycle_hook_name      = each.value.lifecycle_hook_name                 # "tf-as-lifecycle-hook"
  lifecycle_transition     = each.value.lifecycle_transition                # "INSTANCE_LAUNCHING"
  default_result           = try(each.value.default_result, "CONTINUE")     # "CONTINUE"
  heartbeat_timeout        = try(each.value.heartbeat_timeout, 500)         # 500
  notification_metadata    = try(each.value.notification_metadata, null)    # "tf test"
  notification_target_type = try(each.value.notification_target_type, null) # "CMQ_QUEUE"
  notification_queue_name  = try(each.value.notification_queue_name, null)  # "lifcyclehook"
  notification_topic_name  = try(each.value.notification_topic_name, null)

  lifecycle_transition_type = try(each.value.lifecycle_transition_type, "EXTENSION") # The scenario where the lifecycle hook is applied. EXTENSION: the lifecycle hook will be triggered when AttachInstances, DetachInstances or RemoveInstaces is called. NORMAL: the lifecycle hook is not triggered by the above APIs.

  dynamic "lifecycle_command" {
    for_each = try(each.value.lifecycle_command, null) == null ? [] : [1]
    content {
      command_id = each.value.lifecycle_command.command_id
      parameters = try(each.value.lifecycle_command.parameters, null)
    }
  }
}

data "tencentcloud_as_scaling_configs" "as_config" {
  configuration_id = var.as_config_id
}

resource "null_resource" "refresh_trigger" {
  for_each = var.create ? local.as_config_version_map : {}
  triggers = {
    name = each.value
  }
}



resource "tencentcloud_as_start_instance_refresh" "config_changes" {
  for_each              = var.create ? local.as_config_version_map : {}
  auto_scaling_group_id = local.as_group_id
  refresh_mode          = var.refresh_mode # "ROLLING_UPDATE_RESET" # "ROLLING_UPDATE_RESET"
  refresh_settings {
    check_instance_target_health = true
    rolling_update_settings {
      batch_number = var.rolling_update_batch_number
      batch_pause  = "AUTOMATIC" // "AUTOMATIC" No pauses.  FIRST_BATCH_PAUSE
      max_surge = var.rolling_update_max_surge
    }
  }
  timeouts {
    create = var.refresh_timeout
  }
  lifecycle {
    replace_triggered_by = [
      null_resource.refresh_trigger[each.key]
    ]
    ignore_changes = [
      refresh_settings
    ]
  }
}
locals {
  as_config_id      = var.create ? concat(tencentcloud_as_scaling_config.as_config.*.id, [""])[0] : ""
  as_config_version = data.tencentcloud_as_scaling_configs.as_config.configuration_list[0].version_number
}

data "tencentcloud_images" "this" {
  count             = var.enable_image_family ? 0 : 1
  os_name           = var.image_id == null ? var.os_name : null
  image_type        = var.image_type
  image_id          = var.image_id
  image_name_regex  = var.image_id == null ? var.image_name : null
}

resource "tencentcloud_as_scaling_config" "as_config" {
  count                      = var.create ? 1 : 0
  configuration_name         = var.configuration_name

  image_id = var.enable_image_family ? null : (
    var.image_id != null ? var.image_id : try(data.tencentcloud_images.this[0].images[0].image_id)
  )
  image_family               = var.enable_image_family ? var.image_family : null
  instance_types             = var.instance_types
  project_id                 = var.project_id
  system_disk_type           = var.system_disk_type
  system_disk_size           = var.system_disk_size

  instance_charge_type       = var.instance_charge_type
  instance_charge_type_prepaid_period     = var.instance_charge_type == "PREPAID"   ? var.instance_charge_type_prepaid_period : null
  instance_charge_type_prepaid_renew_flag = var.instance_charge_type == "PREPAID"   ? var.instance_charge_type_prepaid_renew_flag : null
  spot_instance_type         = var.instance_charge_type == "SPOTPAID" ? var.spot_instance_type : null
  spot_max_price             = var.instance_charge_type == "SPOTPAID" ? var.spot_max_price : null

  dynamic "data_disk" {
    for_each = var.data_disks
    content {
      disk_type            = try(data_disk.value.type, "CLOUD_PREMIUM")
      disk_size            = try(data_disk.value.size, 50)
      delete_with_instance = var.delete_with_instance
    }
  }

  internet_charge_type       = var.internet_charge_type
  internet_max_bandwidth_out = var.allocate_public_ip ? var.internet_max_bandwidth_out : null
  public_ip_assigned         = var.allocate_public_ip

  key_ids                    = var.key_ids
  password                   = var.password
  enhanced_security_service  = var.enhanced_security_service
  enhanced_monitor_service   = var.enhanced_monitor_service
  enhanced_automation_tools_service = var.enhanced_automation_tools_service
  security_group_ids         = var.security_group_ids
  user_data                  = var.user_data_raw == null ? null : base64encode(var.user_data_raw)

  host_name_settings {
    host_name       = var.host_name
    host_name_style = var.host_name_style
  }

  instance_name_settings {
    instance_name       = var.instance_name
    instance_name_style = var.instance_name_style
  }

  cam_role_name  = var.cam_role_name
  instance_tags  = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "tencentcloud_as_scaling_configs" "as_config" {
  depends_on      = [tencentcloud_as_scaling_config.as_config]
  configuration_id = local.as_config_id
}


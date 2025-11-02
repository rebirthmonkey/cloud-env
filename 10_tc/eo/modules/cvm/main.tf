data "tencentcloud_images" "this" {
  os_name = var.image_id == null ? var.os_name : null
  image_type = var.image_id == null ? var.image_type : ["PUBLIC_IMAGE"]
  image_id = var.image_id
  image_name_regex = var.image_id == null ? var.image_name: null
}

data "tencentcloud_instance_types" "these" {
  dynamic "filter" {
    for_each = {for k, v in var.instance_type_filters : k => v if v != null && v != [] }
    content {
      name   = filter.key
      values = filter.value
    }
  }
  cpu_core_count   = var.cpu_core_count
  memory_size      = var.memory_size
  gpu_core_count   = var.gpu_core_count
  exclude_sold_out = true
}

resource "tencentcloud_instance" "cvm_instance" {
  depends_on = [tencentcloud_cam_role_policy_attachment_by_name.binding]
  count  = var.instance_count
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  instance_name     = var.instance_name
  availability_zone = var.availability_zone
  image_id          = data.tencentcloud_images.this.images[0].image_id
  instance_type     = var.instance_type == null ? data.tencentcloud_instance_types.these.instance_types[0].instance_type : var.instance_type
  system_disk_type  = var.system_disk_type
  system_disk_size = var.system_disk_size
  orderly_security_groups   = var.security_group_ids
  key_ids = var.key_ids
  password = var.password
  cam_role_name = var.cam_role_name
  user_data_raw = var.user_data_raw
  project_id = var.project_id
  allocate_public_ip = var.allocate_public_ip
  internet_max_bandwidth_out = var.internet_max_bandwidth_out

  instance_charge_type = var.instance_charge_type
  instance_charge_type_prepaid_period = var.instance_charge_type_prepaid_period
  instance_charge_type_prepaid_renew_flag = var.instance_charge_type_prepaid_renew_flag

  dynamic "data_disks" {
    for_each = var.data_disks
    content {
      data_disk_type = try(data_disks.value.type, "CLOUD_PREMIUM")
      data_disk_size = try(data_disks.value.size, 50)
      delete_with_instance = var.delete_with_instance
    }
  }

  lifecycle {
    ignore_changes = [
      user_data_raw,
      password
    ]
  }
}

resource "tencentcloud_cam_role" "assume_role" {
  count = var.create_assume_role ? 1 : 0
  name        = var.cam_role_name
  document    = <<EOF
{
  "statement": [
    {
      "action":"name/sts:AssumeRole",
      "effect":"allow",
      "principal":{
        "service":"cvm.qcloud.com"
      }
    }
  ],
  "version":"2.0"
}
EOF
  description = var.assume_role_description
  tags = var.tags
}


resource "tencentcloud_cam_policy" "assume_role_policy" {
  count = var.create_assume_role ? 1 : 0
  name        = var.assume_role_policy_name   // ForceNew
  document    = var.assume_role_policy_document
  description = var.assume_role_policy_description
}

resource "tencentcloud_cam_role_policy_attachment_by_name" "binding" {
  depends_on = [tencentcloud_cam_role.assume_role, tencentcloud_cam_policy.assume_role_policy]
  count = var.create_assume_role ? 1 : 0

  role_name   = var.cam_role_name
  policy_name = var.assume_role_policy_name
}

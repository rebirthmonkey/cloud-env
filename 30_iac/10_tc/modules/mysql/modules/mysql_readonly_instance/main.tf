resource "tencentcloud_mysql_readonly_instance" "this" {
  count = var.create_mysql_readonly_instance ? 1 : 0

  instance_name = var.instance_name
  master_instance_id = var.instance_id
  mem_size = var.mem_size
  volume_size = var.volume_size

  auto_renew_flag = var.auto_renew_flag
  charge_type = var.charge_type
  cpu = var.cpu
  device_type = var.device_type
  force_delete = var.force_delete

  intranet_port = var.intranet_port
  prepaid_period = var.prepaid_period
  security_groups = var.security_groups
  vpc_id = var.vpc_id
  subnet_id = var.subnet_id
  zone = var.zone
  tags = var.tags
}

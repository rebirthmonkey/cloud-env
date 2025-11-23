locals {
  create_prometheus_instance = var.create_prometheus_instance
}

################################################################################
# Prometheus Instance
################################################################################
resource "tencentcloud_monitor_tmp_instance" "tmp_instance" {
  count = local.create_prometheus_instance ? 1 : 0

  instance_name       = var.prometheus_instance_name
  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  data_retention_time = var.data_retention_time
  zone                = var.availability_zone
  tags                = var.prometheus_tags
}

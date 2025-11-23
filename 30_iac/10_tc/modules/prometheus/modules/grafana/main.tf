locals {
  create_grafana_instance = var.create_grafana_instance
}

################################################################################
# Grafana Instance
################################################################################
resource "tencentcloud_monitor_grafana_instance" "grafana_instance" {
  count = local.create_grafana_instance ? 1 : 0

  instance_name         = var.grafana_instance_name
  vpc_id                = var.grafana_vpc_id
  subnet_ids            = var.grafana_subnet_ids
  grafana_init_password = var.grafana_init_password
  enable_internet       = var.enable_internet
  is_destroy            = var.is_destroy

  tags = var.grafana_tags
}

################################################################################
# Prometheus and Grafana Attachment
################################################################################
resource "tencentcloud_monitor_tmp_manage_grafana_attachment" "attachment" {
  grafana_id  = local.create_grafana_instance ? tencentcloud_monitor_grafana_instance.grafana_instance[0].id : var.grafana_instance_id
  instance_id = var.prometheus_instance_id
}

output "grafana_id" {
  description = "The Id of Grafana Instance."
  value       = var.grafana_instance_id != "" ? var.grafana_instance_id : concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].id, [""])[0]
}

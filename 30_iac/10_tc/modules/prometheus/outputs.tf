output "prometheus_id" {
  description = "The Id of Prometheus Instance."
  value       = var.create_prometheus_instance ? concat(tencentcloud_monitor_tmp_instance.tmp_instance[*].id, [""])[0] : var.prometheus_instance_id
}

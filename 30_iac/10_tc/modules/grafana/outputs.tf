# 已有
output "grafana_id" {
  description = "The Id of Grafana Instance."
  value       = var.grafana_instance_id != "" ? var.grafana_instance_id : concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].id, [""])[0]
}

# 新增：实例内部/外部访问地址、实例号等
output "grafana_instance_id" {
  description = "Grafana instance_id (short id)."
  value       = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].instance_id, [""])[0], null)
}

output "grafana_internal_url" {
  description = "Grafana 内网访问域名（内网可达）。"
  value       = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].internal_url, [""])[0], null)
}

output "grafana_internet_url" {
  description = "Grafana 公网访问域名（如果 enable_internet = true）。"
  value       = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].internet_url, [""])[0], null)
}

output "grafana_root_url" {
  description = "Grafana root URL（控制台显示的根地址）。"
  value       = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].root_url, [""])[0], null)
}

output "grafana_vpc_id" {
  value = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].vpc_id, [""])[0], null)
}

output "grafana_subnet_ids" {
  value = try(concat(tencentcloud_monitor_grafana_instance.grafana_instance[*].subnet_ids, [[]])[0], null)
}

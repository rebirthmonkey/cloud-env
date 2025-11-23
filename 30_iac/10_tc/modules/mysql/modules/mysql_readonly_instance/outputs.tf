output "mysql_readonly_instance_id" {
  description = "The id of created resource tencentcloud_mysql_readonly_instance"
  value       = try(tencentcloud_mysql_readonly_instance.this[0].id, "")
}

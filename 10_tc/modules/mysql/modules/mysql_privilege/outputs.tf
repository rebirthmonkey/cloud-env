output "mysql_privilege_id" {
  description = "The id of created resource tencentcloud_mysql_privilege."
  value       = try(tencentcloud_mysql_privilege.this[0].id, "")
}

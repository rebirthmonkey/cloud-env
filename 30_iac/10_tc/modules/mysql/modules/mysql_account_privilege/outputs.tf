output "account_privilege_id" {
  description = "The id of created resource tencentcloud_mysql_account_privilege."
  value       = try(tencentcloud_mysql_account_privilege.this[0].id, "")
}

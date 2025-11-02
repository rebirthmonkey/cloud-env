output "backup_policy_id" {
  description = "The id of backup policy."
  value       = try(tencentcloud_mysql_backup_policy.this[0].id, "")
}

output "binlog_period" {
  description = "Retention period for binlog in days."
  value       = concat(tencentcloud_mysql_backup_policy.this.*.binlog_period, [""])[0]
}

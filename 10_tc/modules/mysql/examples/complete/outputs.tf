output "instance_id" {
  description = ""
  value       = module.mysql.db_instance_id
}

output "gtid" {
  description = ""
  value       = module.mysql.gtid
}

output "internet_host" {
  description = ""
  value       = module.mysql.internet_host
}

output "internet_port" {
  description = ""
  value       = module.mysql.internet_port
}

output "intranet_ip" {
  description = ""
  value       = module.mysql.intranet_ip
}

output "locked" {
  description = ""
  value       = module.mysql.locked
}

output "status" {
  description = ""
  value       = module.mysql.status
}

output "task_status" {
  description = ""
  value       = module.mysql.task_status
}

output "account_ids" {
  description = "Account id list which returned by the account resource created.If not created,returns `[]`."
  value       = module.mysql.account_ids
}

output "backup_policy_id" {
  description = "The id of backup policy."
  value       = module.mysql.backup_policy_id
}

output "binlog_period" {
  description = "Retention period for binlog in days."
  value       = module.mysql.binlog_period
}

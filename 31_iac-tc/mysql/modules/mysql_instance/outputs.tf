output "db_instance_id" {
  description = "The instance id of mysql."
  value       = try(tencentcloud_mysql_instance.this[0].id, "")
}

output "gtid" {
  description = "Is GTID activated."
  value       = concat(tencentcloud_mysql_instance.this.*.gtid, [""])[0]
}

output "internet_host" {
  description = "Host for public access."
  value       = concat(tencentcloud_mysql_instance.this.*.internet_host, [""])[0]
}

output "internet_port" {
  description = "Access port for public access."
  value       = concat(tencentcloud_mysql_instance.this.*.internet_port, [""])[0]
}

output "intranet_ip" {
  description = "instance intranet IP."
  value       = concat(tencentcloud_mysql_instance.this.*.intranet_ip, [""])[0]
}

output "locked" {
  description = "Indicates whether the instance is locked. 0 - No; 1 - Yes."
  value       = concat(tencentcloud_mysql_instance.this.*.locked, [""])[0]
}

output "status" {
  description = "Instance status. Available values: 0 - Creating; 1 - Running; 4 - Isolating; 5 - Isolated."
  value       = concat(tencentcloud_mysql_instance.this.*.status, [""])[0]
}

output "task_status" {
  description = "Indicates which kind of operations is being executed."
  value       = concat(tencentcloud_mysql_instance.this.*.task_status, [""])[0]
}

output "root_password" {
  sensitive = true
  value = local.root_password
}

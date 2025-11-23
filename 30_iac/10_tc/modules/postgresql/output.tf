output "postgresql_ids" {
  value = {
    for k, r in tencentcloud_postgresql_instance.pg : k => r.id
  }
}

output "postgresql_private_ips" {
  value = {
    for k, r in data.tencentcloud_postgresql_instances.pg : k => r.instance_list[0].private_access_ip
  }
}


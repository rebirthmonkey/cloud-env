output "domain_instance_id" {
  value       = tencentcloud_dnspod_domain_instance.instance.*.id
  description = "domain instance id"
}

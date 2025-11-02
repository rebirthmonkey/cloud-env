output "id" {
  value = { for k, r in tencentcloud_redis_instance.redis: k => r.id }
}

//output "azs" {
//  value = data.tencentcloud_availability_zones.az
//}

output "ip" {
  value = { for k, r in data.tencentcloud_redis_instances.redis: k => r.instance_list[0].ip }
}

output "password" {
  value = { for k, r in tencentcloud_redis_instance.redis: k => nonsensitive(r.password) }
#  sensitive = true
}
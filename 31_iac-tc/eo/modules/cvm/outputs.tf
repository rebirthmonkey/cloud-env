output "cvm_instance_ids" {
  value       = tencentcloud_instance.cvm_instance.*.id
  description = "CVM Ids"
}

output "public_ips" {
  value = tencentcloud_instance.cvm_instance.*.public_ip
}

output "user_data_raw" {
  value = tencentcloud_instance.cvm_instance.*.user_data_raw
}

output "inner_ip" {
  value = tencentcloud_instance.cvm_instance.*.private_ip
}
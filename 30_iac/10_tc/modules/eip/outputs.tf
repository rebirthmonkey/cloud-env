output "ids" {
  value = { for eip_name, eip in tencentcloud_eip.eips: eip_name => eip.id }
}
output "public_ips" {
  value = { for eip_name, eip in tencentcloud_eip.eips: eip_name => eip.public_ip }
}
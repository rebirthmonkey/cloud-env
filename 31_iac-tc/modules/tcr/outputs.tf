output "tcr_id" {
  value = tencentcloud_tcr_instance.foo.id
}
output "tcr_name" {
  value = local.name
}
output "user_name" {
  value = tencentcloud_tcr_token.my_token.user_name
}
output "token" {
  value = tencentcloud_tcr_token.my_token.token
}
output "access_ips" {
  value = { for k, att in tencentcloud_tcr_vpc_attachment.foo: att.vpc_id => att.access_ip}
}
output "service_accounts" {
  value = tencentcloud_tcr_service_account.service_accounts
}
output "clb_id" {
  description = "clb id"
  value = tencentcloud_clb_instance.clb.id
}

output "clb_name" {
  value = tencentcloud_clb_instance.clb.clb_vips
}

output "clb_domain" {
  value = tencentcloud_clb_instance.clb.domain
}

output "listener_id" {
  value = var.create_listener ? tencentcloud_clb_listener.HTTP_listener[0].listener_id : 0
}

output "clb_this" {
  value = tencentcloud_clb_instance.clb
}

output "clb_listener" {
  value = tencentcloud_clb_listener.HTTP_listener
}

output "clb_listener_rule" {
  value = tencentcloud_clb_listener_rule.HTTP_listener_rule
}

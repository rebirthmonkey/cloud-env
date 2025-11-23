output "policy_name" {
  value       = tencentcloud_cam_policy.this.name
  description = "The created policy name."
}

output "policy_id" {
  value       = tencentcloud_cam_policy.this.id
  description = "The created policy ID."
}

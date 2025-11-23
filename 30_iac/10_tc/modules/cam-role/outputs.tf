output "role_name" {
  value       = tencentcloud_cam_role.this.name
  description = "The created role name."
}

output "role_arn" {
  value       = tencentcloud_cam_role.this.role_arn
  description = "The created role ARN."
}

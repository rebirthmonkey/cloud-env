variable "cross_policy_name" {
  type        = string
  description = "自定义策略名称（例如 policy_prometheus-cross-account）。"
  default     = "policy_prometheus-cross-account"
}

variable "assume_role_resources" {
  type        = list(string)
  description = "策略中允许 Assume 的目标资源（建议填具体目标角色 ARN，调试期可留空= *）。"
  default     = []
}


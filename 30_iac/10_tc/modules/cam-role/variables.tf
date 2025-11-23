variable "cross_role_name" {
  type        = string
  description = "角色名称（例如 role_prometheus-cross-account）。"
  default     = "role_prometheus-cross-account"
}

variable "carrier_service" {
  type        = string
  description = "角色载体服务：CVM 用 cvm.qcloud.com；TKE 用 ccs.qcloud.com。"
  default     = "cvm.qcloud.com"
}

variable "attach_policy_names" {
  type        = list(string)
  description = "需要绑定到该角色的策略名称列表（例如包含 policy_prometheus-cross-account）。"
  default     = []
}


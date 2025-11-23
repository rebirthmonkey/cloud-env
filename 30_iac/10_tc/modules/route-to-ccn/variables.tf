variable "route_table_id" {
  description = "VPC 的路由表 ID"
  type        = string
}

variable "destination_cidr" {
  description = "目标 CIDR，一般为 0.0.0.0/0"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ccn_id" {
  description = "CCN 的 ID，例如 ccn-xxxxx"
  type        = string
}

variable "description" {
  description = "路由备注"
  type        = string
  default     = "default route to CCN"
}


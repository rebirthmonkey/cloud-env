variable "route_table_id" {
  description = "VPC 的路由表 ID"
  type        = string
}

variable "nat_gateway_id" {
  description = "NAT 网关 ID"
  type        = string
}

variable "description" {
  description = "路由备注"
  type        = string
  default     = "default route to NAT"
}



variable "create_private_dns" {
  type = bool
  default = true
  description = "Create or use an existed one"
}
variable "private_dns_zone_id" {
  type = string
  default = ""
  description = "Used when create_private_dns is false. Specify an existed private_dns"
}

variable "domain" {
  type = string
  default = ""
  description = "The Domain"
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "vpc_sets" {
  type = any
  default = []
}
variable "dns_forward_status" {
  type = string
  default = "DISABLED"
  description = "// Whether to enable subdomain recursive DNS. Valid values: ENABLED, DISABLED. Default value: DISABLED."
}
variable "account_vpc_sets" {
  type = any
  default = []
}
variable "remark" {
  type = string
  default = "remark"
  description = "The remark of Domain."
}

variable "records" {
  type = any
  default = {}
  description = "Map of rescords to create. sub_domain is the map key.see `tencentcloud_private_dns_record` "
}
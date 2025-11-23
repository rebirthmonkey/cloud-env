variable "random_tcr_suffix" {
  type = bool
  default = false
  description = "tcr name is global uniq. True for a random suffix"
}

variable "tcr_name" {
  type = string
  description = "tcr name"
}
variable "instance_type" {
  type = string
  default = "basic"
  description = "TCR types. Valid values are: standard, basic, premium."
}
variable "open_public_operation" {
  type = bool
  default = false
  description = "Control public network access"
}

variable "delete_bucket" {
  type = bool
  default = false
  description = "Indicate to delete the COS bucket which is auto-created with the instance or not."
}

variable "registry_charge_type" {
  type = number
  default = 1
  description = "1: postpaid; 2: prepaid. "
}

variable "vpc_attachments" {
  type = any
  default = {}
  description = "Map of vpc_attachments to create. vpc_id is the map key.see `tencentcloud_tcr_vpc_attachment` "
}

// The variables below are key descriptions for each vpc_attachments. They are not used
variable "vpc_id" {
  type = string
  default = null
  description = "vpc id to attach"
}
variable "subnet_id" {
  type = string
  default = null
  description = "subnet id to set endpoint"
}
variable "enable_public_domain_dns" {
  type = bool
  default = false
}
variable "enable_vpc_domain_dns" {
  type = bool
  default = true
}

variable "security_policies" {
  type = list(any)
  default = []
  description = ""
}
variable "namespaces" {
  type = any
  default = {}
  description = "namespace map, see `tencentcloud_tcr_namespace`"
}

variable "service_accounts" {
  type = any
  default = {}
  description = "service_account map, see `tencentcloud_tcr_service_account`"
}
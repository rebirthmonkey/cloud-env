variable "create_domain" {
  type = bool
  default = false
}

variable "random_domain" {
  type = bool
  default = false
  description = "for testing. True for a random domain name"
}

variable "domain" {
  type = string
  default = ""
  description = "The Domain"
}
variable "remark" {
  type = string
  default = "remark"
  description = "The remark of Domain."
}

variable "do_resolve" {
  type = bool
  default = true
  description = "in some cases we do not want to resolve the records"
}

variable "records" {
  type = any
  default = {}
  description = "Map of rescords to create. sub_domain is the map key.see `tencentcloud_dnspod_record` "
}
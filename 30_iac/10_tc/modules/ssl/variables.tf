variable "domain" {
  type    = string
  default = null
  description = "(Required, String, ForceNew) Specify domain name."
}

variable "dv_auth_method" {
  type = string
  default = null
  description = "(Required, String) Specify DV authorize method. "
}

variable "alias" {
  type = string
  default = null
  description = "(Optional, String) Specify alias for remark."
}

variable "contact_email" {
  type = string
  default = null
  description = "(Optional, String) Email address."
}

variable "contact_phone" {
  type = string
  default = null
  description = "(Optional, String) Phone number."
}

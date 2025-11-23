variable "domain" {
  type    = string
  default = null
  description = "(Required, String) The Domain."
}

variable "record_type" {
  type = string
  default = null
  description = "(Required, String) The record type."
}

variable "value" {
  type = string
  default = null
  description = "(Required, String) The record value."
}

variable "sub_domain" {
  type = string
  default = "@"
  description = "(Optional, String) The host records, default value is @."
}

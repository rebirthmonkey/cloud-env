variable "region" {
  type    = string
  default = "ap-singapore"
  description = "region, like: ap-singapore"
}

variable "sys_user" {
  type    = string
  default = "38190DA8-C692-4332-8C2B-5EC68C685699"
  description = "cvm user, gernerate default by uuidgen"
}

variable "sys_password" {
  type    = string
  default = "7201B641-DB63-40A7-901E-C516239FDFD9"
  description = "cvm user, gernerate default by uuidgen"
}

variable "sys_domain" {
  type    = string
  default = null
  description = "The Domain."
}

variable "ssl_email" {
  type = string
  default = null
  description = "(Optional, String) Email address."
}

variable "ssl_phone" {
  type = string
  default = null
  description = "(Optional, String) Phone number."
}

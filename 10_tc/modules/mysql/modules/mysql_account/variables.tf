variable "create_mysql_account" {
  description = "Whether to create mysql account."
  type        = bool
  default     = true
}

variable "mysql_id" {
  description = "Mysql instance id."
  type        = string
  default     = ""
}

variable "name" {
  description = "Account name."
  type        = string
  default     = ""
}

variable "password" {
  description = "Operation password of the account."
  type        = string
  default     = ""
}

variable "description" {
  description = "Database description."
  type        = string
  default     = ""
}

variable "host" {
  description = "Account host, default is %."
  type        = string
  default     = "%"
}

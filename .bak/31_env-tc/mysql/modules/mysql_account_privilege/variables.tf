variable "create_account_privilege" {
  description = "Whether to create mysql account privilege."
  type        = bool
  default     = false
}

variable "account_name" {
  description = "Account name."
  type        = string
  default     = ""
}

variable "database_names" {
  description = "List of specified database name."
  type        = list(string)
  default     = []
}

variable "mysql_id" {
  description = "Mysql instance id."
  type        = string
  default     = ""
}

variable "account_host" {
  description = "Account host, default is %."
  type        = string
  default     = "%"
}

variable "privileges" {
  description = "List of database permission."
  type        = list(string)
  default     = []
}

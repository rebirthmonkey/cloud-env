variable "create_mysql_privilege" {
  description = "Whether to create mysql privilege."
  type        = bool
  default     = false
}

variable "account_name" {
  description = "Account name for mysql privilege."
  type        = string
  default     = ""
}

variable "global" {
  description = "Global privileges."
  type        = list(string)
  default     = []
}

variable "mysql_id" {
  description = "Mysql instance id."
  type        = string
  default     = ""
}

variable "account_host" {
  description = "Account host for mysql privilege, default is %."
  type        = string
  default     = "%"
}

variable "column" {
  description = "Column privileges list."
  type        = list(map(any))
  default     = []
}

variable "database" {
  description = "Database privileges list."
  type        = list(map(any))
  default     = []
}

variable "table" {
  description = "Table privileges list."
  type        = list(map(any))
  default     = []
}

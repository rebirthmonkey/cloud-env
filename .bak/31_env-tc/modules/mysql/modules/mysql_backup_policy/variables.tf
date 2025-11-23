variable "create_backup_policy" {
  description = "Whether to create mysql backup policy."
  type        = bool
  default     = true
}

variable "mysql_id" {
  description = "Mysql instance id."
  type        = string
  default     = ""
}

variable "backup_model" {
  description = "Backup method. Supported values include: 'physical' - physical backup."
  type        = string
  default     = "physical"
}

variable "backup_time" {
  description = " Instance backup time, in the format of \"HH:mm-HH:mm\". Time setting interval is four hours. Default to \"02:00-06:00\". The following value can be supported: 02:00-06:00, 06:00-10:00, 10:00-14:00, 14:00-18:00, 18:00-22:00, and 22:00-02:00."
  type        = string
  default     = "02:00-06:00"
}

variable "retention_period" {
  description = " Instance backup retention days. Valid values: [7-730]. And default value is 7."
  type        = number
  default     = 7
}

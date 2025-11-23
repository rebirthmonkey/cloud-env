variable "create_mysql_readonly_instance" {
  description = "Whether to create mysql readonly instance."
  type        = bool
  default     = true
}

variable "instance_id" {
  description = "The id of a mysql master instance."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "The name of a mysql instance."
  type        = string
  default     = ""
}

variable "mem_size" {
  description = "Memory size (in MB)."
  type = number
  default     = 1000
}

variable "volume_size" {
  description = "Disk size (in GB)."
  type = number
  default     = 200
}

variable "cpu" {
  description = "Cpu cores."
  type = number
  default     = 2
}

variable "device_type" {
  description = "Device type."
  type = string
  default     = "UNIVERSAL"
}

variable "security_groups" {
  description = "Security groups to use."
  type        = list(string)
  default     = []
}

# MySQL instance payment configuration
variable "charge_type" {
  description = "Pay type of instance, valid values are PREPAID, POSTPAID. Default is POSTPAID."
  type = string
  default     = "POSTPAID"
}

variable "prepaid_period" {
  description = "Period of instance. NOTES: Only supported prepaid instance."
  default     = 1
}

variable "auto_renew_flag" {
  description = "Auto renew flag. NOTES: Only supported prepaid instance."
  type = number
  default     = 0
}

variable "force_delete" {
  description = "Indicate whether to delete instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance. When the main mysql instance set true, this para of the readonly mysql instance will not take effect."
  type = bool
  default     = false
}

# MySQL instance net configuration
variable "intranet_port" {
  description = "Public access port, rang form 1024 to 65535 and default value is 3306."
  type = number
  default     = 3306
}

variable "vpc_id" {
  description = "ID of VPC, which can be modified once every 24 hours and can't be removed."
  type = string
  default     = ""
}

variable "subnet_id" {
  description = "Private network ID. If vpc_id is set, this value is required."
  type = string
  default     = ""
}

variable "zone" {
  description = "Zone information of readonly instance."
  type = string
  default = ""
}

variable "tags" {
  description = "Instance tags."
  type        = map(string)
  default     = {}
}

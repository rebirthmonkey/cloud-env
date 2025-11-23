variable "instances" {
  type = any
  default = {}
  description = "map of redis instances, see `tencentcloud_redis_instance`"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to assign to the redis instance"
}

variable "vpc_ids" {
  type =  map(string)
  default = {}
  description = "Map of vpc ids"
}

variable "subnet_ids" {
  type =  map(map(string))
  default = {}
  description = "Map of subnet ids, key is subnet name, sub key is az"
}

// The variables below are not used. They are descriptions of the instance map
variable "type_id" {
  type        = string
  default     = 15
  description = <<EOF
Type of the redis instance, available values include:
  2: Redis 2.8 Memory Edition (Standard Architecture).
  3: CKV 3.2 Memory Edition (Standard Architecture).
  4: CKV 3.2 Memory Edition (Cluster Architecture).
  6: Redis 4.0 Memory Edition (Standard Architecture).
  7: Redis 4.0 Memory Edition (Cluster Architecture).
  8: Redis 5.0 Memory Edition (Standard Architecture).
  9: Redis 5.0 Memory Edition (Cluster Architecture).
  15: Redis 6.2 Memory Edition (Standard Architecture).
  16: Redis 6.2 Memory Edition (Cluster Architecture).
Please check the document https://www.tencentcloud.com/zh/document/product/239/32069 for up-to-date type ids.
EOF
}

variable "redis_shard_num" {
  type        = number
  default     = 1
  description = "Number of shards of the redis instance, only valid when type_id is 4, 7, 9, 16 or any other cluster type"
}

variable "replica_zone_names" {
  type        = list(string)
  default     = null
  description = "List of zone names within which to create the redis replicas, non-null indicates to create a multi-zone redis instance"
}

variable "name" {
  type        = string
  default     = null
  description = "Name of the redis instance"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "ID of the vpc within which to create the redis instance"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "ID of the subnet within which to create the master redis replica"
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "availability_zone"
}

variable "mem_size" {
  type        = number
  default     = 4096
  description = "Memory size of the redis instance ( for standalone type ) or a single shard ( for cluster type )"
}

variable "charge_type" {
  type        = string
  default     = "POSTPAID"
  description = "Charge type of the redis instance"
  validation {
    condition     = can(regex("^(POSTPAID|PREPAID)$", var.charge_type))
    error_message = "Valid values are POSTPAID and PREPAID"
  }
}

variable "auto_renew_flag" {
  type = number
  default = 1
  description = "Auto-renew flag. 0 - default state (manual renewal); 1 - automatic renewal; 2 - explicit no automatic renewal."
}

variable "prepaid_period" {
  type = number
  default = 1
  description = "(time unit is month) of the prepaid instance, NOTE: it only works when charge_type is set to PREPAID. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36"
}


variable "no_auth" {
  type = bool
  default = false
}

variable "password" {
  type        = string
  default     = null
  description = "Password of the redis instance"
}

variable "port" {
  type        = number
  default     = 6379
  description = "Port of the redis instance"
}

variable "project_id" {
  type        = number
  default     = 0
  description = "Project id of the redis instance"
}

variable "security_groups" {
  type        = list(string)
  default     = null
  description = "List of security group ids to associate with the redis instance"
}
variable "force_delete" {
  type = bool
  default = false
  description = "Indicate whether to delete Redis instance directly or not. Default is false. If set true, the instance will be deleted instead of staying recycle bin. Note: only works for PREPAID instance."
}
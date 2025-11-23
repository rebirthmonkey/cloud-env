variable instance_name {
  type        = string
  default     = "ckafka-instance-tf-test"
  description = "Instance name."
}
variable charge_type {
  type        = string
  default     = "PREPAID"
  description = "Type of charge.(`PREPAID`; `POSTPAID_BY_HOUR`)"
}
variable band_width {
  type        = number
  default     = 40
  description = "Instance bandwidth in MBps."
}
variable disk_size {
  type        = number
  default     = 500
  description = "Disk Size. Its interval varies with bandwidth, and the input must be within the interval, which can be viewed through the control. If it is not within the interval, the plan will cause a change when first created."
}
variable disk_type {
  type        = string
  default     = "CLOUD_BASIC"
  description = "Type of disk.(ssd: `CLOUD_SSD`; sata: `CLOUD_BASIC`)"
}
variable period {
  type        = number
  default     = 1
  description = "Prepaid purchase time, such as 1, is one month."
}
variable instance_type {
  type        = number
  default     = 1
  description = "Description of instance type. profession: 1, standard: 1(general), 2(standard), 3(advanced), 4(capacity), 5(specialized-1), 6(specialized-2), 7(specialized-3), 8(specialized-4), 9(exclusive)."
}
variable kafka_version {
  type        = string
  default     = "2.4.1"
  description = "Kafka version (0.10.2/1.1.1/2.4.1)."
}
variable msg_retention_time {
  type        = number
  default     = 1300
  description = "The maximum retention time of instance logs, in minutes. the default is 10080 (7 days), the maximum is 30 days, and the default 0 is not filled, which means that the log retention time recovery policy is not enabled."
}
variable multi_zone_flag {
  type        = bool
  default     = false
  description = "Indicates whether the instance is multi zones. NOTE: if set to true, zone_ids must set together."
}
variable partition {
  type        = number
  default     = 800
  description = "Partition Size. Its interval varies with bandwidth, and the input must be within the interval, which can be viewed through the control. If it is not within the interval, the plan will cause a change when first created."
}
variable public_network {
  type        = number
  default     = null
  description = "Timestamp."
}
variable renew_flag {
  type        = number
  default     = 0
  description = "Prepaid automatic renewal mark, 0 means the default state, the initial state, 1 means automatic renewal, 2 means clear no automatic renewal (user setting)."
}
variable vpc_id {
  type        = string
  default     = ""
  description = "Vpc id."
}
variable subnet_id {
  type        = string
  default     = ""
  description = "Subnet id."
}
variable zone_id {
  type        = number
  default     = null
  description = "Available zone id."
}
variable zone_ids {
  type        = list(string)
  default     = []
  description = "List of available zone id. NOTE: this argument must set together with `multi_zone_flag`."
}
variable tag_set {
  type        = map(string)
  default     = null
  description = "Tag set of instance."
}
variable config {
  type = object({
    auto_create_topic_enable   = bool
    default_num_partitions     = number
    default_replication_factor = number
  })
  default = {
    auto_create_topic_enable   = true
    default_num_partitions     = 3
    default_replication_factor = 3
  }
  description = "Instance configuration."
}
variable dynamic_retention_config {
  type        = object({
    bottom_retention        = number
    disk_quota_percentage   = number
    enable                  = number
    step_forward_percentage = number
  })
  default     = {
    bottom_retention        = 0
    disk_quota_percentage   = 0
    enable                  = 1
    step_forward_percentage = 0
  }
  description = "Dynamic message retention policy configuration."
}


variable resource_type {
  type        = string
  default     = "TOPIC"
  description = "ACL resource type. Valid values are `UNKNOWN`, `ANY`, `TOPIC`, `GROUP`, `CLUSTER`, `TRANSACTIONAL_ID`. and `TOPIC` by default. Currently, only TOPIC is available, and other fields will be used for future ACLs compatible with open-source Kafka."
}
variable resource_name {
  type        = string
  default     = "topic-tf-test"
  description = "ACL resource name, which is related to `resource_type`. For example, if `resource_type` is `TOPIC`, this field indicates the topic name; if `resource_type` is `GROUP`, this field indicates the group name."
}
variable operation_type {
  type        = string
  default     = "WRITE"
  description = "ACL operation mode. Valid values: `UNKNOWN`, `ANY`, `ALL`, `READ`, `WRITE`, `CREATE`, `DELETE`, `ALTER`, `DESCRIBE`, `CLUSTER_ACTION`, `DESCRIBE_CONFIGS` and `ALTER_CONFIGS`."
}
variable permission_type {
  type        = string
  default     = "ALLOW"
  description = "ACL permission type. Valid values: `UNKNOWN`, `ANY`, `DENY`, `ALLOW`. and `ALLOW` by default. Currently, CKafka supports `ALLOW` (equivalent to allow list), and other fields will be used for future ACLs compatible with open-source Kafka."
}
variable host {
  type        = string
  default     = "*"
  description = "IP address allowed to access. The default value is *, which means that any host can access."
}
variable principal {
  type        = string
  default     = "*"
  description = "User list. The default value is *, which means that any user can access. The current user can only be one included in the user list."
}
variable ckafka_topic {
  type        = object({
    topic_name                     = string
    note                           = string
    replica_num                    = number
    partition_num                  = number
    enable_white_list              = bool
    ip_white_list                  = list(string)
    clean_up_policy                = string
    sync_replica_min_num           = number
    unclean_leader_election_enable = bool
    segment                        = number
    retention                      = number
    max_message_bytes              = number
  })
  default     = null
  description = "Configuration of creation parameters for Ckafka Topic"
}
variable ckafka_acl {
  type        = object({
    resource_type   = string
    resource_name   = string
    operation_type  = string
    permission_type = string
    host            = string
    principal       = string
  })
  default     = null
  description = "Configuration of creation parameters for Ckafka Acl"
}
variable "create_private_dns_record" {
  type = bool
  default = true
  description = "Create or use an existed one"
}
variable "record_intranet_ip" {
  type = string
  default = ""
  description = "record_intranet_ip"
}
variable "records" {
  type = any
  default = {}
  description = "Map of rescords to create. sub_domain is the map key.see `tencentcloud_private_dns_record` "
}

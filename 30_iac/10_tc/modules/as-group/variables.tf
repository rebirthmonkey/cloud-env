variable "project_id" {
  type        = number
  description = "project id."
  default     = 0
}

variable "create" {
  type    = bool
  default = true
  description = "create AS group or not."
}

# group
variable "as_config_id" {
  type = string
  default = ""
  description = "auto scaling config id"
}

variable "scaling_group_name" {
  type = string
  default = ""
  description = "Name of a scaling group"
}

variable "as_config_version" {
  type = string
  default = ""
  description = "auto scaling config version number"
}

variable "vpc_id" {
  type    = string
  default = ""
  description = "ID of VPC network."
}
variable "subnet_ids" {
  type    = list(string)
  default = []
  description = "ID list of subnet, and for VPC it is required."
}

variable "forward_balancers" {
  type    = any
  default = []
  description = "List of application load balancers."
}

variable "as_max_size" {
  type    = number
  default = 3
  description = "Maximum number of CVM instances. Valid value ranges: (0~2000)."
}
variable "as_min_size" {
  type    = number
  default = 1
  description = "Minimum number of CVM instances. Valid value ranges: (0~2000)."
}
variable "as_desired_capacity" {
  type    = number
  default = 0
  description = "Desired volume of CVM instances, which is between max_size and min_size."
}

variable "termination_policies" {
  type        = list(string)
  default     = ["OLDEST_INSTANCE"]
  description = "Available values for termination policies. Valid values: OLDEST_INSTANCE and NEWEST_INSTANCE."
}

variable "multi_zone_subnet_policy" {
  type        = string
  default     = "EQUALITY"
  description = "Multi zone or subnet strategy, Valid values: PRIORITY and EQUALITY."
}

variable "internet_charge_type" {
  type    = string
  default = "TRAFFIC_POSTPAID_BY_HOUR"
  description = "Charge types for network traffic. Valid values: BANDWIDTH_PREPAID, TRAFFIC_POSTPAID_BY_HOUR and BANDWIDTH_PACKAGE."
}
variable "host_name_style" {
  type    = string
  default = "UNIQUE"
  description = "The style of the host name of the cloud server, the value range includes ORIGINAL and UNIQUE, the default is ORIGINAL; ORIGINAL, the AS directly passes the HostName filled in the input parameter to the CVM, and the CVM may append a sequence to the HostName number, the HostName of the instance in the scaling group will conflict; UNIQUE, the HostName filled in as a parameter is equivalent to the host name prefix, AS and CVM will expand it, and the HostName of the instance in the scaling group can be guaranteed to be unique."
}
variable "retry_policy" {
  type    = string
  default = "IMMEDIATE_RETRY"
  description = "Available values for retry policies. Valid values: IMMEDIATE_RETRY and INCREMENTAL_INTERVALS."
}
variable "replace_monitor_unhealthy" {
  type    = bool
  default = false
  description = "Enables unhealthy instance replacement. If set to true, AS will replace instances that are flagged as unhealthy by Cloud Monitor."
}
variable "replace_load_balancer_unhealthy" {
  type    = bool
  default = true
  description = "Enable unhealthy instance replacement. If set to true, AS will replace instances that are found unhealthy in the CLB health check."
}

variable "health_check_type" {
  type    = string
  default = null
  description = "Health check type of instances in a scaling group."
}
variable "lb_health_check_grace_period" {
  type    = number
  default = 0
  description = "Grace period of the CLB health check during which the IN_SERVICE instances added will not be marked as CLB_UNHEALTHY.Valid range: 0-7200, in seconds. Default value: 0."
}

variable "enable_auto_scaling" {
  default = true
  type = bool
  description = " If enable auto scaling group."
}

variable "tags" {
  default = {}
  type = map(string)
  description = " Tags of a scaling group."
}

# as policies
variable "as_policies" {
  type    = any
  default = {}
  description = "AS policies."
}

# hooks
variable "hooks" {
  type    = any
  default = {}
  description = "lifecycle hooks."
}

# trigger
variable "trigger_refresh" {
  type        = bool
  default     = false
  description = "if trigger refresh instances when config version changed"
}

variable "rolling_update_batch_number" {
  type        = number
  default     = 1
  description = "Batch quantity. The batch quantity should be a positive integer greater than 0, but cannot exceed the total number of instances pending refresh."
}

variable "rolling_update_max_surge" {
  type = number
  default = null
  description = "Maximum Extra Quantity. After setting this parameter, a batch of pay-as-you-go extra instances will be created according to the launch configuration before the rolling update starts, and the extra instances will be destroyed after the rolling update is completed."
}

variable "refresh_mode" {
  type = string
  default = "ROLLING_UPDATE_RESET"
  description = "Refresh mode: ROLLING_UPDATE_RESET or ROLLING_UPDATE_REPLACE"
}

variable "refresh_timeout" {
  default = "20m"
  type = string
  description = "timeout for the as group refresh"
}
# ccn
variable "create_ccn" {
  description = "Controls if CCN should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "ccn_name" {
  description = "Name of the CCN to be created, and maximum length does not exceed 60 bytes."
  type        = string
  default     = "ccn-example"
}

variable "bandwidth_limit_type" {
  description = "The speed limit type of CCN. Valid values: `INTER_REGION_LIMIT`, `OUTER_REGION_LIMIT`."
  type        = string
  default     = "OUTER_REGION_LIMIT"
}

variable "charge_type" {
  description = "Billing mode of CCN. Valid values: `PREPAID`, `POSTPAID`."
  type        = string
  default     = "POSTPAID"
}

variable "ccn_description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = ""
}

variable "qos" {
  description = "Service quality of CCN. Valid values: `PT`, `AU`, `AG`. The default is `AU`."
  type        = string
  default     = "AU"
}

variable "ccn_tags" {
  description = "Tags of the CCN to be created."
  type        = map(string)
  default     = {}
}

variable "ccn_id" {
  description = "The ID of ccn which to attach."
  type        = string
  default     = ""
}

# ccn attachment
variable "attach_ccn" {
  description = "Controls if attach CCN instance to other network instances."
  type        = bool
  default     = true
}

variable "instance_type" {
  description = "Type of attached instance network, and available values include VPC, DIRECTCONNECT, BMVPC and VPNGW."
  type        = string
  default     = "VPC"
}

variable "instance_id" {
  description = "ID of instance which will be attached."
  type        = string
  default     = ""
}

variable "instance_region" {
  description = "The region which the attached instance locates at."
  type        = string
  default     = ""
}

variable "ccn_uin" {
  description = "Uin of the ccn attached. If not set, which means the uin of this account. This parameter is used with case when attaching ccn of other account to the instance of this account."
  type        = string
  default     = ""
}

variable "attachment_description" {
  description = "Description of the CCN to be created, and maximum length does not exceed 100 bytes."
  type        = string
  default     = ""
}

# ccn bandwidth limit
variable "set_bandwith_limit" {
  description = "Control if set ccn bandwidth limit."
  type        = bool
  default     = false
}

variable "src_region" {
  description = "Limitation of region."
  type        = string
  default     = "ap-guangzhou"
}

variable "dst_region" {
  description = "Destination area restriction. If the `CCN` rate limit type is `OUTER_REGION_LIMIT`, this value does not need to be set."
  type        = string
  default     = "ap-chengdu"
}

variable "bandwidth_limit" {
  description = "Limitation of bandwidth."
  type        = number
  default     = 0
}
variable "route_overlap_flag" {
  description = "Whether to enable route overlap flag for CCN."
  type        = bool
  default     = false
}

# variable "config_route" {
#   description = "Controls if config ccn route."
#   type        = bool
#   default     = false
# }

# variable "route_id" {
#   description = "The ID of ccn route."
#   type        = string
#   default     = ""
# }

# variable "switch" {
#   description = "If enable CCN route. `on`: Enable, `off`: Disable."
#   type        = string
#   default     = "on"
# }

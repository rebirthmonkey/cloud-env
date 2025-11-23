variable "project_id" {
  type        = number
  description = "project id."
  default     = 0
}

variable "instance_name" {
  description = "the name of instance to create."
  type        = string
  default     = null
}

variable "instance_count" {
  description = "the number of instances to create."
  type        = number
  default     = 1
}

variable "availability_zone" {
  description = "The available zone for the instance.  "
  type        = string
  default     = null
}

variable "image_id" {
  description = "The image to use for the instance. Changing image_id will cause the instance reset."
  type        = string
  default     = null
}

variable "image_name" {
  type = string
  default = null
  description = "help to find image when image id is not set, conflict with os_name"
}

variable "image_type" {
  type = list(string)
  default = ["PUBLIC_IMAGE"]
  description = "help to find image when image id is not set"
}

variable "os_name" {
  type = string
  default = null
  description = "help to find image when image id is not set, conflict with image_name"
}

variable "instance_type" {
  description = "instance type of instance."
  default     = null
  type = string
}

variable "instance_type_filters" {
  type = map(string)
  default = {}
  description = "filter to get instance_type"

}
variable "cpu_core_count" {
  type = number
  default = null
  description = "filter to get instance_type"
}

variable "memory_size" {
  type = number
  default = null
  description = "filter to get instance_type"
}

variable "gpu_core_count" {
  type = number
  default = null
  description = "filter to get instance_type"
}

variable "system_disk_type" {
  description = "System disk type. For more information on limits of system disk types, see Storage Overview. Valid values: LOCAL_BASIC: local disk, LOCAL_SSD: local SSD disk, CLOUD_SSD: SSD, CLOUD_PREMIUM: Premium Cloud"
  type        = string
  default     = "CLOUD_PREMIUM"
}

variable "system_disk_size" {
  type        = number
  description = "Size of the system disk. unit is GB, Default is 50GB. If modified, the instance may force stop."
  default     = 50
}

variable "allocate_public_ip" {
  description = "Associate a public IP address with an instance in a VPC or Classic. Boolean value, Default is false."
  default     = false
  type        = bool
}

variable "vpc_id" {
  description = "The ID of a VPC network. If you want to create instances in a VPC network, this parameter must be set or the default vpc will be used."
  type        = string
  default     = null
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The ID of a VPC subnet. If you want to create instances in a VPC network, this parameter must be set or the default subnet will be used."
}

variable "internet_max_bandwidth_out" {
  type        = number
  default     = null
  description = "Maximum outgoing bandwidth to the public network, measured in Mbps (Mega bits per second). This value does not need to be set when allocate_public_ip is false."
}

variable "key_ids" {
  description = "Key ids of the Key Pair to use for the instance; which can be managed using the `tencentcloud_key_pair` resource"
  type        = list(string)
  default     = null
}

variable "password" {
  description = "Login password of the instance. For Linux instances, the password must include 8-30 characters, and contain at least two of the following character sets: [a-z], [A-Z], [0-9] and [()`~!@#$%^&*-+="
  type        = string
  default     = null
}

variable "security_group_ids" {
  type        = list(string)
  default     = null
  description = "A list of orderly security group IDs to associate with."
}

variable "cbs_block_devices" {
  description = "Additional CBS block devices to attach to the instance. see resource tencentcloud_cbs_storage."
  type        = list(map(string))
  default     = []
}

variable "cbs_block_device_ids" {
  description = "Attach exist CBS block devices to the instance by id.  see resource tencentcloud_cbs_storage."
  type        = list(string)
  default     = []
}

variable "cbs_tags" {
  description = "Additional tags to assign to cbs resource."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC, private IP must be an IP within the subnet specified by subnet_id。"
  type        = string
  default     = null
}


variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = true
}


variable "user_data_raw" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data_raw to pass base64-encoded binary data directly. Use this instead of user_data_raw whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "cam_role_name" {
  description = "CAM role name authorized to access."
  type        = string
  default     = null
}

variable "instance_charge_type" {
  description = "he charge type of instance. Valid values are PREPAID, POSTPAID_BY_HOUR, SPOTPAID and CDHPAID. The default is POSTPAID_BY_HOUR.TencentCloud International only supports POSTPAID_BY_HOUR and CDHPAID.  CDHPAID instance must set cdh_instance_type and cdh_host_id."
  type        = string
  default     = "POSTPAID_BY_HOUR"
}

variable "instance_charge_type_prepaid_period" {
  description = "The tenancy (time unit is month) of the prepaid instance, NOTE: it only works when instance_charge_type is set to PREPAID. Valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 24, 36."
  type = number
  default = null
}

variable "instance_charge_type_prepaid_renew_flag" {
  description = "Auto renewal flag. Valid values: NOTIFY_AND_AUTO_RENEW: notify upon expiration and renew automatically, NOTIFY_AND_MANUAL_RENEW: notify upon expiration but do not renew automatically, DISABLE_NOTIFY_AND_MANUAL_RENEW: neither notify upon expiration nor renew automatically. Default value: NOTIFY_AND_MANUAL_RENEW. If this parameter is specified as NOTIFY_AND_AUTO_RENEW, the instance will be automatically renewed on a monthly basis if the account balance is sufficient. NOTE: it only works when instance_charge_type is set to PREPAID."
  type = string
  default = null
}

variable "cdh_instance_type" {
  description = "Type of instance created on cdh, the value of this parameter is in the format of CDH_XCXG based on the number of CPU cores and memory capacity. Note: it only works when instance_charge_type is set to CDHPAID."
  type        = string
  default     = null
}

variable "cdh_host_id" {
  description = "Id of cdh instance. Note: it only works when instance_charge_type is set to CDHPAID."
  type        = string
  default     = null
}

variable "placement_group_id" {
  description = "The Placement Group Id to start the instance in, see tencentcloud_placement_group."
  type        = string
  default     = ""
}

variable "placement_group_name" {
  description = "The Placement group name to start the instance in, see tencentcloud_placement_group. will ignore if placement_group_id passed."
  type        = string
  default     = ""
}

variable "placement_group_type" {
  description = "The Placement Group type to start the instance in, see tencentcloud_placement_group. will ignore if placement_group_id passed."
  type        = string
  default     = "HOST"
}

variable "eni_ids" {
  description = "A list of eni_id to bind with the instance. see resource tencentcloud_eni."
  type        = list(string)
  default     = []
}

variable "delete_with_instance" {
  type = bool
  default = true
  description = " ForceNew. Decides whether the disk is deleted with instance(only applied to CLOUD_BASIC, CLOUD_SSD and CLOUD_PREMIUM disk with POSTPAID_BY_HOUR instance), default is true."
}

variable "data_disks" {
  type = any
  default = []
  description = "List of data_disks to create. type, size supported"
}

variable "create_assume_role" {
  type = bool
  default = false
}

variable "assume_role_description" {
  type = string
  default = ""
}

variable "assume_role_policy_name" {
  type = string
  default = ""
}

variable "assume_role_policy_document" {
  type = string
  default = ""
}

variable "assume_role_policy_description" {
  type = string
  default = ""
}
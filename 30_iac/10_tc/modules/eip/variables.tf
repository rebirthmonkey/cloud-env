variable "eips" {
  type = any
  default = {}
  description = "Map of eips to create. Eip name is the map key.see `tencentcloud_eip` "
}

// The variables below are key descriptions for each resource. They are not used
variable "name" {
  type = string
  default = "eip-new"
  description = "eip name"
}
variable "internet_charge_type" {
  type = string
  default = "TRAFFIC_POSTPAID_BY_HOUR"
  description = "The charge type of eip. Valid values: BANDWIDTH_PACKAGE, BANDWIDTH_POSTPAID_BY_HOUR, BANDWIDTH_PREPAID_BY_MONTH and TRAFFIC_POSTPAID_BY_HOUR."
}
variable "internet_max_bandwidth_out" {
  type = number
  default = 100
  description = "The bandwidth limit of EIP, unit is Mbps."
}
variable "type" {
  type = string
  default = "EIP"
  description = "The type of eip. Valid value: EIP and AnycastEIP and HighQualityEIP. Default is EIP"
}
variable "internet_service_provider" {
  type = string
  default = "BGP"
  description = "Internet service provider of eip. Valid value: BGP, CMCC, CTCC and CUCC."
}
variable "bandwidth_package_id" {
  type = string
  default = null
  description = "ID of bandwidth package, it will set when internet_charge_type is BANDWIDTH_PACKAGE"
}
variable "tags" {
  type = map(string)
  default = {}
  description = "The tags of eip."
}
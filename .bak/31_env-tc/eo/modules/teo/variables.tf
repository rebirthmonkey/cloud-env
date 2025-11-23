
variable "create_zone" {
  type = bool
  default = true
  description = ""
}

variable "need_verify" {
  type = bool
  default = true
  description = "whether the zone needs verify. If true, no domain and certificate will be created"
}

variable "zone_id" {
  type = string
  default = ""
}

variable "zone_name" {
  type = string
  default = ""
}

variable "zone_settings" {
  type = any
  default = {}
  description = "deprecated by tencentcloud_teo_l7_acc_setting. see `tencentcloud_teo_zone_setting`"
}

variable "l7_acc_setting" {
  type = any
  default = {}
  description = "see `tencentcloud_teo_l7_acc_setting`"
}
variable "type" {
  type = string
  default = "partial"
  description = "the value of this parameter is as follows, and the default is partial if not filled in. Valid values: partial: CNAME access; full: NS access; noDomainAccess: No domain access."
}
variable "area" {
  type = string
  default = ""
  description = "Valid values: global: Global availability zone; mainland: Chinese mainland availability zone; overseas: Global availability zone (excluding Chinese mainland)."
}
variable "alias_zone_name" {
  type = string
  default = ""
  description = "Limit the input to a combination of numbers, English, - and _, within 20 characters. "
}
variable "paused" {
  type = bool
  default = false
  description = "Indicates whether the site is disabled."
}
variable "plan_id" {
  type = string
  default = ""
  description = "The target Plan ID to be bound. When you have an existing Plan in your account, you can fill in this parameter to directly bind the site to the Plan."
}
variable "tags" {
  type = map(string)
  default = {}
}

variable "acceleration_domains" {
  type = any
  default = {}
  description = "see `tencentcloud_teo_acceleration_domain`"
}
variable "origin_groups" {
  type = any
  default = {}
  description = "see `tencentcloud_teo_origin_group`"
}

# Deprecated

variable "rule_engines" {
  type = any
  default = []
  description = "see `tencentcloud_teo_rule_engine`"
}


variable "certificates" {
  type = any
  default = {}
  description = "see `tencentcloud_teo_certificate_config`"
}

variable "teo_log_delivery" {
  description = "A map of log delivery configurations"
  type = any
  default = {}
}

variable "l7_acc_rules" {
  description = " "
  type = any
  default = []
}

variable "l4_proxies" {
  type = any
  default = {}
  description = ""
}
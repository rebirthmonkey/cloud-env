variable "logsets" {
  type = any
  default = {}
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "alarms" {
  type = any
  default = {}
}
// Deprecated
// logset
#variable "logset_name" {
#  description = "The logset name."
#  type        = string
#  default     = ""
#}
#
#variable "logset_tags" {
#  description = "Tag description list."
#  type        = map(string)
#  default     = {}
#}
#
#// topics
#variable "topics" {
#  type = any
#  default = {}
#  description = "map of topics. see `tencentcloud_cls_topic` and `tencentcloud_cls_index`"
#}

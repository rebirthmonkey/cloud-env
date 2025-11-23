variable "region" {
  description = "The region where the VPN gateway and other resources are located. Example: 'ap-jakarta'."
  type        = string
  default     = "ap-jakarta"
}

variable "create" {
  type = bool
  default = true
  description = "create or not"
}

variable "bucket_name" {
  type = string
  default = ""
  description = "TODO: chang with naming convention"
}


variable "bucket" {
  type = any
  default = {}
  description = "see `tencentcloud_cos_bucket`"
}

variable "cam_policies" {
  type = any
  default = {}
  description = "see `tencentcloud_cam_policy`"
}
variable "bucket_policies" {
  type = any
  default = []
  description = "see `tencentcloud_cos_bucket_policy`"
}

variable "tags" {
  description = "A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

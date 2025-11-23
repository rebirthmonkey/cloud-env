# ccn
variable "create_prometheus_instance" {
  description = "Controls if Prometheus instance should be created (it affects almost all resources)."
  type        = bool
  default     = true
}

variable "prometheus_instance_id" {
  description = "ID of Prometheus Instance."
  type        = bool
  default     = true
}

variable "prometheus_instance_name" {
  description = "Name of Prometheus instance to be created."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "Vpc Id of Prometheus instance."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet Id of Prometheus instance."
  type        = string
  default     = null
}

variable "data_retention_time" {
  description = "Data retention time."
  type        = number
  default     = 30
}

variable "availability_zone" {
  description = "Availability Zone."
  type        = string
  default     = "ap-guangzhou-3"
}

variable "prometheus_tags" {
  description = "Tags of the Prometheus instance to be created."
  type        = map(string)
  default     = {}
}


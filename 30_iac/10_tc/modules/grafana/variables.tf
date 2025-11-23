# ccn
variable "create_grafana_instance" {
  description = "Controls if Grafana instance should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "prometheus_instance_id" {
  description = "ID of Prometheus instance."
  type        = string
  default     = null
}

variable "grafana_instance_id" {
  description = "ID of Grafana instance."
  type        = string
  default     = null
}

variable "grafana_instance_name" {
  description = "Name of Grafana instance to be created."
  type        = string
  default     = null
}

variable "grafana_vpc_id" {
  description = "Vpc Id of Grafana instance."
  type        = string
  default     = null
}

variable "grafana_subnet_ids" {
  description = "Subnet Id of Grafana instance."
  type        = set(string)
  default     = null
}

variable "grafana_init_password" {
  description = "Grafana server admin password."
  type        = string
  sensitive   = true
  default     = null
}

variable "enable_internet" {
  description = "Control whether grafana could be accessed by internet."
  type        = bool
  default     = false
}

variable "is_destroy" {
  description = "Whether to clean up completely, the default is false."
  type        = bool
  default     = false
}

variable "grafana_tags" {
  description = "Tags of the Grafana instance to be created."
  type        = map(string)
  default     = {}
}

variable "region" {
  type = string
  default = ""
}

variable "project_id" {
  type = number
  default = 0
}

variable "security_groups" {
  type = list(string)
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "create_private_dns_record" {
  type        = bool
  default     = false
}

variable "record_intranet_ip" {
  type        = string
  default     = ""
}

variable "records" {
  type = any
  default = {}
}

variable "instances" {
  type = any
  description = <<EOT
A map of PostgreSQL instance configurations. Example:

instances = {
  default = {
    name               = "my-pg"
    availability_zone  = "ap-guangzhou-1"
    vpc_id             = "vpc-xxx"
    subnet_id          = "subnet-xxx"
    memory             = 4
    cpu                = 2
    storage            = 100
    engine_version     = "14.3"
    root_user          = "pgadmin"
    root_password      = "securepassword"
    security_groups    = ["sg-xxx"]
  }
}
EOT
}


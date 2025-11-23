variable "region" {
  type    = string
  default = "ap-jakarta"
}

variable "create" {
  type =bool
  default =  true
  description = "create or not"
}

variable "name" {
  type = string
  default = ""
}
variable "clb" {
  type = any
  default = {}
  description = "see clb module"
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "dynamic_vip" {
  type = string
  default = ""
}

variable "internet_bandwidth_max_out" {
  type = number
  default = 10
}

variable "internet_charge_type" {
  type = string
  default = ""
}

variable "master_zone_id" {
  type = string
  default = ""
}

variable "slave_zone_id" {
  type = string
  default = ""
}

variable "clb_listeners" {
  type = list(map(string))
  default = []
}

variable "clb_listener_rules" {
  type = list(map(string))
  default = []
}

variable "listener_name" {
  type = string
  default = ""
}

variable "protocol" {
  type = string
  default = ""
}

variable "port" {
  type = number
  default = 80
}

variable "domain" {
  type = string
  default = ""
}

variable "url" {
  type = string
  default = ""
}

variable "listener_index" {
  type = number
  default = 0
}

variable "create_listener" {
  type        = bool
  default     = true
  description = "Whether to create a CLB Listener."
}

variable "create_listener_rules" {
  type        = bool
  default     = false
  description = "Whether to create a CLB Listener rules."
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs to bind with the CLB"
  default     = []
}

variable "load_balancer_pass_to_target" {
  type        = bool
  description = "Enable default pass-through between CLB and backend"
  default     = false
}

variable "network_type" {
  type        = string
  default     = "OPEN" 
  description = "CLB的网络类型，OPEN为公网，INTERNAL为内网"
}

variable "subnet_id" {
  type    = string
  default = ""
  description = "CLB所属子网，仅内网CLB必填"
}

variable "create_tls_listener" {
  type        = bool
  default     = false
  description = "是否创建 TLS(HTTPS/TCP_SSL) 监听器"
}
variable "tls_protocol" {
  type        = string
  default     = "TCP_SSL"   # 或 "HTTPS"
}
variable "tls_port" {
  type        = number
  default     = 443
}
variable "tls_listener_name" {
  type        = string
  default     = ""
}

# 证书
variable "certificate_id" {
  type        = string
  default     = null
}
variable "certificate_ssl_mode" {
  type        = string
  default     = "UNIDIRECTIONAL"  # 或 "MUTUAL"
}
variable "certificate_ca_id" {
  type        = string
  default     = null              # 双向认证才需要
}

# HTTPS 规则（域名/路径）
variable "tls_domain" {
  type        = string
  default     = ""                # 空=默认规则（匹配所有域名）
}
variable "tls_url" {
  type        = string
  default     = "/"               # 路径前缀
}

# 后端（按 IP 绑定），并提供一个开关先不绑定
variable "enable_backend_attach" {
  type        = bool
  default     = true
  description = "若为 true，则把 backends 绑定到该 HTTPS 规则"
}

# 后端（按 IP 绑定）
variable "backends" {
  type = list(object({
    ip     = string
    port   = number
    weight = optional(number, 10)
  }))
  default = []
}


# 健康检查（HTTPS 监听走 HTTP 健康检查）
variable "hc_switch" {
  type        = bool
  default     = true
  description = "Enable health check for TLS listener."
}

variable "hc_time_out" {
  type        = number
  default     = 2
}

variable "hc_interval_time" {
  type        = number
  default     = 5
}

variable "hc_health_num" {
  type        = number
  default     = 3
}

variable "hc_unhealth_num" {
  type        = number
  default     = 3
}

# 0 表示按后端端口
variable "hc_port" {
  type        = number
  default     = 0
}

# 仅 HTTP/HTTPS 有效，TCP/TCP_SSL 不会用到
variable "hc_http_code" {
  type        = string
  default     = "31"
}

# 仅 HTTP/HTTPS 有效
variable "hc_http_path" {
  type        = string
  default     = "/"
}

# 仅 HTTP/HTTPS 有效
variable "hc_http_domain" {
  type        = string
  default     = ""
}

variable "listener_target_type" {
  type        = string
  default     = "NODE"   # TCP_SSL 推荐 NODE 或 TARGETGROUP 二选一
  description = "Backend target type for listener. Valid: NODE, TARGETGROUP."
}

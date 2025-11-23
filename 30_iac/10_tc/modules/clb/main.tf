resource "tencentcloud_clb_instance" "clb" {
  network_type = var.network_type
  clb_name     = var.name
  vpc_id       = var.vpc_id
  subnet_id = var.network_type == "INTERNAL" ? var.subnet_id : null  
  dynamic_vip = try(var.dynamic_vip, false)
  # internet_bandwidth_max_out = try(var.internet_bandwidth_max_out, null)
  # internet_charge_type       = try(var.internet_charge_type, null)
  # 只在公网CLB时设置这两个字段
  internet_bandwidth_max_out = var.network_type == "OPEN" ? var.internet_bandwidth_max_out : null
  internet_charge_type       = var.network_type == "OPEN" ? var.internet_charge_type : null

  master_zone_id = try(var.master_zone_id, null)
  slave_zone_id  = try(var.slave_zone_id, null)
  tags = var.tags

  security_groups = var.security_groups

  load_balancer_pass_to_target = true

}

resource "tencentcloud_clb_listener" "HTTP_listener" {
  count  = var.create_listener ? length(var.clb_listeners) : 0
  clb_id        = tencentcloud_clb_instance.clb.id
  listener_name              = var.clb_listeners[count.index].listener_name
  port                       = var.clb_listeners[count.index].port
  protocol                   = var.clb_listeners[count.index].protocol
  depends_on    = [tencentcloud_clb_instance.clb]
}

resource "tencentcloud_clb_listener_rule" "HTTP_listener_rule" {
  count                      = var.create_listener_rules ? length(var.clb_listener_rules) : 0
  listener_id                = tencentcloud_clb_listener.HTTP_listener[var.clb_listener_rules[count.index].listener_index].listener_id
  clb_id                     = tencentcloud_clb_instance.clb.id
  domain                     = var.clb_listener_rules[count.index].domain
  url                        = var.clb_listener_rules[count.index].url
  depends_on    = [tencentcloud_clb_listener.HTTP_listener]
}

# HTTPS/TCP_SSL 监听器（前端 443 TLS 终止）
# ===== TLS Listener (TCP_SSL 单向/可选双向) =====
resource "tencentcloud_clb_listener" "https" {
  count         = var.create_tls_listener && var.tls_protocol == "HTTPS" ? 1 : 0
  clb_id        = tencentcloud_clb_instance.clb.id
  listener_name = coalesce(var.tls_listener_name, "tls-443")

  protocol      = "HTTPS"
  port          = var.tls_port
  target_type   = var.listener_target_type
  scheduler     = "WRR"

  # 证书（单向 TLS）
  certificate_id       = var.certificate_id
  certificate_ssl_mode = var.certificate_ssl_mode
  certificate_ca_id    = (
    var.certificate_ssl_mode == "MUTUAL" && var.certificate_ca_id != null && var.certificate_ca_id != "" ?
    var.certificate_ca_id : null
  )
  depends_on = [tencentcloud_clb_instance.clb]
}

# HTTPS 规则（域名+路径）
# 说明：domain="" 表示默认规则；url="/" 表示根路径
# =========================
resource "tencentcloud_clb_listener_rule" "https_rule" {
  count      = var.create_tls_listener && var.tls_protocol == "HTTPS" ? 1 : 0
  clb_id     = tencentcloud_clb_instance.clb.id
  listener_id= tencentcloud_clb_listener.https[0].listener_id

  domain     = var.tls_domain
  url        = var.tls_url

  depends_on = [tencentcloud_clb_listener.https]
}


# 按规则绑定后端（IP:PORT）
resource "tencentcloud_clb_attachment" "https_attach" {
  for_each    = (var.create_tls_listener && var.tls_protocol == "HTTPS" && var.enable_backend_attach) ? { for b in var.backends : "${b.ip}:${b.port}" => b } : {}

  clb_id      = tencentcloud_clb_instance.clb.id
  listener_id = tencentcloud_clb_listener.https[0].listener_id
  rule_id     = tencentcloud_clb_listener_rule.https_rule[0].rule_id  # HTTPS 必须带 rule_id

  targets {
    eni_ip = each.value.ip
    port   = each.value.port
    weight = try(each.value.weight, 10)
  }

  depends_on = [tencentcloud_clb_listener_rule.https_rule]
}
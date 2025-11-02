locals {
  this_clb_info      = data.tencentcloud_clb_instances.this.clb_list
  clb_id             = tencentcloud_clb_instance.this.id
  log_set_id         = var.log_set_id == "" && var.create_clb_log ? tencentcloud_clb_log_set.set[0].id : var.log_set_id
  log_topic_id       = var.log_topic_id == "" && var.create_clb_log ? tencentcloud_clb_log_topic.topic[0].id : var.log_topic_id
  listener_resources = tencentcloud_clb_listener.listener
  rule_resources     = tencentcloud_clb_listener_rule.listener_rule
}

resource "tencentcloud_clb_instance" "this" {
  project_id      = var.project_id
  clb_name        = var.clb_name
  tags            = var.clb_tags
  network_type    = var.network_type
  vpc_id          = var.vpc_id == null ? 0 : var.vpc_id
  subnet_id       = var.vpc_id != null ? var.subnet_id : null
  security_groups = var.security_groups
  dynamic_vip = var.network_type == "OPEN"? var.dynamic_vip : null
  sla_type = var.sla_type

  log_set_id   = local.log_set_id
  log_topic_id = local.log_topic_id

  address_ip_version           = var.address_ip_version
  bandwidth_package_id         = var.bandwidth_package_id
  internet_bandwidth_max_out   = var.internet_bandwidth_max_out
  internet_charge_type         = var.internet_charge_type
  load_balancer_pass_to_target = var.load_balancer_pass_to_target
  master_zone_id               = var.master_zone_id
  slave_zone_id                = var.slave_zone_id
  dynamic "snat_ips" {
    for_each = var.snat_ips
    content {
      subnet_id = snat_ips.value.subnet_id
      ip        = snat_ips.value.ip
    }
  }
  snat_pro                  = var.snat_pro
  target_region_info_region = var.target_region_info_region
  target_region_info_vpc_id = var.target_region_info_vpc_id
  zone_id                   = var.zone_id

  lifecycle {
    ignore_changes = [
      // tke-clusterId is a preserved tag used by TKE for service attaching CLBs
      tags["tke-clusterId"],
    ]
  }
}

data "tencentcloud_clb_instances" "this" {
  clb_id = local.clb_id
}

resource "tencentcloud_clb_log_set" "set" {
  count  = var.log_set_id == "" && var.create_clb_log ? 1 : 0
  period = var.clb_log_set_period
}

resource "tencentcloud_clb_log_topic" "topic" {
  count      = var.log_topic_id == "" && var.create_clb_log ? 1 : 0
  log_set_id = local.log_set_id
  topic_name = var.clb_log_topic_name
}

resource "tencentcloud_clb_listener" "listener" {
  count  = var.create_listener ? length(var.clb_listeners) : 0
  clb_id = tencentcloud_clb_instance.this.id

  listener_name              = var.clb_listeners[count.index].listener_name
  port                       = var.clb_listeners[count.index].port
  protocol                   = var.clb_listeners[count.index].protocol
  certificate_ca_id          = lookup(var.clb_listeners[count.index], "certificate_ca_id", null)
  certificate_id             = lookup(var.clb_listeners[count.index], "certificate_id", null)
  certificate_ssl_mode       = lookup(var.clb_listeners[count.index], "certificate_ssl_mode", null)
  health_check_context_type  = lookup(var.clb_listeners[count.index], "health_check_context_type", null)
  health_check_health_num    = lookup(var.clb_listeners[count.index], "health_check_health_num", null)
  health_check_http_code     = lookup(var.clb_listeners[count.index], "health_check_http_code", null)
  health_check_http_domain   = lookup(var.clb_listeners[count.index], "health_check_http_domain", null)
  health_check_http_method   = lookup(var.clb_listeners[count.index], "health_check_http_method", null)
  health_check_http_path     = lookup(var.clb_listeners[count.index], "health_check_http_path", null)
  health_check_http_version  = lookup(var.clb_listeners[count.index], "health_check_http_version", null)
  health_check_interval_time = lookup(var.clb_listeners[count.index], "health_check_interval_time", null)
  health_check_port          = lookup(var.clb_listeners[count.index], "health_check_port", null)
  health_check_recv_context  = lookup(var.clb_listeners[count.index], "health_check_recv_context", null)
  health_check_send_context  = lookup(var.clb_listeners[count.index], "health_check_send_context", null)
  health_check_switch        = lookup(var.clb_listeners[count.index], "health_check_switch", null)
  health_check_time_out      = lookup(var.clb_listeners[count.index], "health_check_time_out", null)
  health_check_type          = lookup(var.clb_listeners[count.index], "health_check_type", null)
  health_check_unhealth_num  = lookup(var.clb_listeners[count.index], "health_check_unhealth_num", null)
  scheduler                  = lookup(var.clb_listeners[count.index], "scheduler", null)
  session_expire_time        = lookup(var.clb_listeners[count.index], "session_expire_time", null)
  sni_switch                 = lookup(var.clb_listeners[count.index], "sni_switch", null)
  target_type                = lookup(var.clb_listeners[count.index], "target_type", null)
}

resource "tencentcloud_clb_listener_rule" "listener_rule" {
  count                      = var.create_listener_rules ? length(var.clb_listener_rules) : 0
  clb_id                     = tencentcloud_clb_instance.this.id
  listener_id                = tencentcloud_clb_listener.listener[var.clb_listener_rules[count.index].listener_index].listener_id
  domain                     = var.clb_listener_rules[count.index].domain
  url                        = var.clb_listener_rules[count.index].url
  certificate_ca_id          = lookup(var.clb_listener_rules[count.index], "certificate_ca_id", null)
  certificate_id             = lookup(var.clb_listener_rules[count.index], "certificate_id", null)
  certificate_ssl_mode       = lookup(var.clb_listener_rules[count.index], "certificate_ssl_mode", null)
  forward_type               = lookup(var.clb_listener_rules[count.index], "forward_type", null)
  health_check_health_num    = lookup(var.clb_listener_rules[count.index], "health_check_health_num", null)
  health_check_http_code     = lookup(var.clb_listener_rules[count.index], "health_check_http_code", null)
  health_check_http_domain   = lookup(var.clb_listener_rules[count.index], "health_check_http_domain", null)
  health_check_http_method   = lookup(var.clb_listener_rules[count.index], "health_check_http_method", null)
  health_check_http_path     = lookup(var.clb_listener_rules[count.index], "health_check_http_path", null)
  health_check_interval_time = lookup(var.clb_listener_rules[count.index], "health_check_interval_time", null)
  health_check_switch        = lookup(var.clb_listener_rules[count.index], "health_check_switch", null)
  health_check_time_out      = lookup(var.clb_listener_rules[count.index], "health_check_time_out", null)
  health_check_type          = lookup(var.clb_listener_rules[count.index], "health_check_type", null)
  health_check_unhealth_num  = lookup(var.clb_listener_rules[count.index], "health_check_unhealth_num", null)
  http2_switch               = lookup(var.clb_listener_rules[count.index], "http2_switch", null)
  scheduler                  = lookup(var.clb_listener_rules[count.index], "scheduler", null)
  session_expire_time        = lookup(var.clb_listener_rules[count.index], "session_expire_time", null)
  target_type                = lookup(var.clb_listener_rules[count.index], "target_type", null)
}

resource "tencentcloud_clb_redirection" "clb_redirection" {
  count                   = var.create_clb_redirections ? length(var.clb_redirections) : 0
  clb_id                  = tencentcloud_clb_instance.this.id
  target_listener_id      = local.rule_resources[var.clb_redirections[count.index].target_listener_rule_index].listener_id
  target_rule_id          = local.rule_resources[var.clb_redirections[count.index].target_listener_rule_index].rule_id
  delete_all_auto_rewrite = lookup(var.clb_redirections[count.index], "delete_all_auto_rewrite", null)
  is_auto_rewrite         = lookup(var.clb_redirections[count.index], "is_auto_rewrite", null)
  source_listener_id      = lookup(var.clb_redirections[count.index], "source_listener_rule_index", null) != null ? local.rule_resources[var.clb_redirections[count.index].source_listener_rule_index].listener_id : null
  source_rule_id          = lookup(var.clb_redirections[count.index], "source_listener_rule_index", null) != null ? local.rule_resources[var.clb_redirections[count.index].source_listener_rule_index].rule_id : null
}
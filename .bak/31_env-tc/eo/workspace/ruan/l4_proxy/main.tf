locals {
  prefix = "ruan"
  zone_id = "zone-3bh2khrx0bek"
  origin_ids = {
    "nginx_nanjing" = "og-3bh3dsddr21p"
    "nginx_singapore" = "og-3bh3dsddqc7o"
  }
}

module "teo" {
  source = "../../../modules/teo"
  create_zone = false
  need_verify = false
  zone_id = local.zone_id
  l4_proxies = {
    singapore = {
      proxy_name = "${local.prefix}-singapore"
      rules = [
        {
          client_ip_pass_through_mode = "OFF"
          origin_port_range           = "9090"
          origin_type                 = "ORIGIN_GROUP"
          origin_value                = [local.origin_ids["nginx_singapore"]]
          port_range = ["9090"]
          protocol             = "TCP"
          rule_tag             = "rule-tag"
          session_persist      = "off"
          session_persist_time = 3600
        }
      ]
    }
  }
}

output "all" {
  value = module.teo
}






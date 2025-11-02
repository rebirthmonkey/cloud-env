locals {
  prefix = "xxxx"
  zone_id = "zone-3a94q08jdek1"
  origin_ids = {
    "nginx_nanjing" = "og-3bcyo02vyll1"
    "nginx_singapore" = "og-3bcyo035yehy"
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






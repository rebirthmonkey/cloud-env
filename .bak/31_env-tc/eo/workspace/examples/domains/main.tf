locals {
  prefix = "xxxx"
  zone_id = "zone-3a94q08jdek1"
  zone_name = "overseasops.com"
  ssl_id = "NL3QTC0c"
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
  acceleration_domains = {
    domain_singapore = {
      domain_name = format("%s-singapore.%s", local.prefix, local.zone_name)
      status = "online"
      origin_info = {
        nginx_1 = {
          origin_type = "ORIGIN_GROUP"
          origin      = local.origin_ids["nginx_singapore"]
        }
      }
      origin_protocol = "HTTP"
      http_origin_port = 9090
    },
    domain_nanjing = {
      domain_name = format("%s-nanjing.%s", local.prefix, local.zone_name)
      status = "online"
      origin_info = {
        nginx_1 = {
          origin_type = "ORIGIN_GROUP"
          origin      = local.origin_ids["nginx_nanjing"]
        }
      }
      origin_protocol = "HTTP"
      http_origin_port = 9090
    }
  }
  certificates = {
    domain_singapore = {
      host = format("%s-singapore.%s", local.prefix, local.zone_name)
      mode    = "sslcert"
      server_cert_infos = {
        ssl = {
          cert_id = local.ssl_id
        }
      }
    },
    domain_nanjing = {
      host = format("%s-nanjing.%s", local.prefix, local.zone_name)
      mode    = "sslcert"
      server_cert_infos = {
        ssl = {
          cert_id = local.ssl_id
        }
      }
    }
  }
}

output "all" {
  value = module.teo
}






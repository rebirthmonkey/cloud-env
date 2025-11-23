locals {
  prefix = "xxxx"
  zone_id = "zone-3a94q08jdek1"
  zone_name = "overseasops.com"
}

module "teo" {
  source = "../../../modules/teo"
  create_zone = false
  need_verify = false
  zone_id = local.zone_id

  l7_acc_rules = [

    {
      rule_name   = "cache"
      description = ["cache-index"]
      branches = [
        {
          condition = "$${http.request.host} in ['${format("%s-singapore.%s", local.prefix, local.zone_name)}']" # and $${http.request.uri.path} in ['/index.html']
          description = ["with sub rules"]
          actions = [
            {
              name             = "Cache"
              cache_parameters = {
                follow_origin = {
                  default_cache          = "on"
                  default_cache_strategy = "off"
                  default_cache_time     = 5
                  switch                 = "on"
                }
              }
            },
          ]
        }
      ]
    }
  ]
}

output "all" {
  value = module.teo
}






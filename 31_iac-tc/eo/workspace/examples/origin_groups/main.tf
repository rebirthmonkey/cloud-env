locals {
  zone_id = "zone-3a94q08jdek1"
}

module "teo" {
  source = "../../../modules/teo"
  create_zone = false
  need_verify = false
  zone_id = local.zone_id
  origin_groups = {
    "singapore" = {
      configuration_type = "weight"
      origin_group_name = "nginx_singapore"
      origin_type        = "GENERAL"
      origin_records = {
        "record_1" = {
          port    = 80
          record  = "43.153.201.63"
          weight  = 100
        }
      }
    },
    "nanjing" = {
      configuration_type = "weight"
      origin_group_name = "nginx_nanjing"
      origin_type        = "GENERAL"
      origin_records = {
        "record_1" = {
          port    = 80
          record  = "1.13.177.4"
          weight  = 100
        }
      }
    }
  }
}

output "all" {
  value = module.teo
}






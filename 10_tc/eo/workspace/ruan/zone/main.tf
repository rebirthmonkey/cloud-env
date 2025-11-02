locals {
  prefix = "ruan"
  zone_name = "overseasops.com"
  plan_id = "edgeone-30duwr3kmjma"
  tags = {
    created: "terraform"
  }
}

module "teo" {
  source = "../../../modules/teo"
  create_zone = true
  need_verify = false
  zone_name = local.zone_name
  alias_zone_name = local.prefix
  plan_id = local.plan_id
  area = "overseas"
  type = "partial"
  tags = local.tags
}

output "all" {
  value = module.teo
}
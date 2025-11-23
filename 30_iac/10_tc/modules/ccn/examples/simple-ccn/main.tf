provider "tencentcloud" {
  region = local.region
}

locals {
  region = "ap-guangzhou"

  ccn_name             = "ccn_test"
  bandwidth_limit_type = "INTER_REGION_LIMIT"
  charge_type          = "POSTPAID"
  ccn_description      = "create for test"
  tags = {
    createdBy = "terraform"
  }

  attach_ccn = false
}

module "ccn" {
  source               = "../../"
  ccn_name             = local.ccn_name
  bandwidth_limit_type = local.bandwidth_limit_type
  charge_type          = local.charge_type
  ccn_description      = local.ccn_description
  ccn_tags             = local.tags

  attach_ccn = local.attach_ccn
}

provider "tencentcloud" {
  region = local.region
}

resource "tencentcloud_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  name       = "tf_ccn_attach_vpc"
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

  instance_type          = "VPC"
  instance_id            = tencentcloud_vpc.vpc.id
  instance_region        = "ap-guangzhou"
  attachment_description = "attach simple vpc"

  set_bandwith_limit = true
  src_region         = "ap-guangzhou"
  dst_region         = "ap-chengdu"
  bandwidth_limit    = 100
}

module "ccn" {
  source = "../../"

  ccn_name             = local.ccn_name
  bandwidth_limit_type = local.bandwidth_limit_type
  charge_type          = local.charge_type
  ccn_description      = local.ccn_description
  ccn_tags             = local.tags

  instance_id            = local.instance_id
  instance_type          = local.instance_type
  instance_region        = local.instance_region
  attachment_description = local.attachment_description

  set_bandwith_limit = local.set_bandwith_limit
  src_region         = local.src_region
  dst_region         = local.dst_region
  bandwidth_limit    = local.bandwidth_limit

}

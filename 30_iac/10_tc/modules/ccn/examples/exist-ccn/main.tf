provider "tencentcloud" {
  region = local.region
}

resource "tencentcloud_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  name       = "tf_ccn_attach_vpc"
}

locals {
  region     = "ap-guangzhou"
  create_ccn = false

  ccn_id                 = "ccn-obxvpddt"
  instance_type          = "VPC"
  instance_id            = tencentcloud_vpc.vpc.id
  instance_region        = "ap-guangzhou"
  attachment_description = "attach simple vpc"
}

module "ccn" {
  source     = "../../"
  create_ccn = local.create_ccn

  ccn_id                 = local.ccn_id
  instance_id            = local.instance_id
  instance_type          = local.instance_type
  instance_region        = local.instance_region
  attachment_description = local.attachment_description
}

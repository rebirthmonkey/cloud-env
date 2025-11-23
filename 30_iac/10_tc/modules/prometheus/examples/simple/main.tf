provider "tencentcloud" {
  region = local.region
}

resource "tencentcloud_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  name       = "tf_prometheus_vpc"
}

resource "tencentcloud_subnet" "subnet" {
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = "tf_prometheus_subnet"
  cidr_block        = "10.0.0.0/16"
  availability_zone = "ap-guangzhou-3"
  is_multicast      = false
}

locals {
  region = "ap-guangzhou"

  prometheus_instance_name = "prometheus_for_test"
  prometheus_vpc_id        = tencentcloud_vpc.vpc.id
  prometheus_subnet_id     = tencentcloud_subnet.subnet.id
  data_retention_time      = 30
  availability_zone        = "ap-guangzhou-3"

  prometheus_tags = {
    "createby" = "terraform"
  }
}

module "prometheus_instance" {
  source = "../../"

  prometheus_instance_name = local.prometheus_instance_name
  vpc_id                   = local.prometheus_vpc_id
  subnet_id                = local.prometheus_subnet_id
  data_retention_time      = local.data_retention_time
  availability_zone        = local.availability_zone
  prometheus_tags          = local.prometheus_tags
}

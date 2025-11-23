provider "tencentcloud" {
  region = local.region
}

resource "tencentcloud_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  name       = "tf_grafana_vpc"
}

resource "tencentcloud_subnet" "subnet" {
  vpc_id            = tencentcloud_vpc.vpc.id
  name              = "tf_grafana_subnet"
  cidr_block        = "10.0.0.0/16"
  availability_zone = "ap-guangzhou-3"
  is_multicast      = false
}

locals {
  region = "ap-guangzhou"

  prometheus_instance_id = "prom-jwqer3q4"

  grafana_instance_name = "grafana_for_test"
  grafana_vpc_id        = tencentcloud_vpc.vpc.id
  grafana_subnet_ids    = [tencentcloud_subnet.subnet.id]
  grafana_init_password = 30
  enable_internet       = false
  is_destroy            = true

  grafana_tags = {
    "createby" = "terraform"
  }
}

module "grafana_instance" {
  source = "../../modules/grafana"

  grafana_instance_name = local.grafana_instance_name
  grafana_vpc_id        = local.grafana_vpc_id
  grafana_subnet_ids    = local.grafana_subnet_ids
  grafana_init_password = local.grafana_init_password
  enable_internet       = local.enable_internet
  is_destroy            = local.is_destroy

  grafana_tags = local.grafana_tags

  prometheus_instance_id = local.prometheus_instance_id
}

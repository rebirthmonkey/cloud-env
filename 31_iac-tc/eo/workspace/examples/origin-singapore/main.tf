locals {
  prefix = "xxxx"
  vpc_cidr = "10.0.0.0/16"
  tags = {created: "terraform"}
  availability_zones = ["ap-singapore-2"]
  subnet_cidrs = ["10.0.0.0/24"]

  cvm_password     = "PassW0rd!"    # 测试机和伸缩组云主机登录密码
  instance_type    = "S5.MEDIUM2"
  os_name          = "CentOS 7.9 64"
  system_disk_size = 50
  user_data_raw    = file("./init.sh")

  well-known-cidrs = [
    # 公司出口 IP 段，如果用其他地址访问，请先找到出口 IP ，加入到这个列表里
    "61.135.194.0/24",
    "111.206.145.0/24",
    "59.152.39.0/24",
    "180.78.55.0/24",
    "111.206.94.0/24",
    "111.206.96.0/24",
  ]

  well-known-ports = ["80", "443", "8080", "9090"]
}


module "network" {
  source           = "git::https://github.com/MaDongdong99/terraform-tencentcloud-vpc.git?ref=master"
  vpc_name         = "${local.prefix}-lab"
  vpc_cidr         = local.vpc_cidr
  vpc_is_multicast = false
  tags             = local.tags

  availability_zones = local.availability_zones
  subnet_name        = "${local.prefix}-lab"
  subnet_cidrs       = local.subnet_cidrs
  subnet_tags        = local.tags
}

module "security_groups" {
  source  = "../../../modules/security_groups"
  security_groups = {
    this = {
      name    = "${local.prefix}-teo-demo"
      ingress = concat(
        [
          {
            action      = "ACCEPT"
            cidr_block  = "10.0.0.0/16" # var.consul_private_network_source_ranges
            protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
            port        = "ALL" # "80-90" # 80, 80,90 and 80-90
            description = ""
          }
        ],
        [
          for cidr in local.well-known-cidrs: {
          action      = "ACCEPT"
          cidr_block  = cidr # var.consul_private_network_source_ranges
          protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
          port        = "ALL" # "80-90" # 80, 80,90 and 80-90
          description = ""
        }
        ], [
          for port in local.well-known-ports: {
            action      = "ACCEPT"
            cidr_block  = "0.0.0.0/0" # var.consul_private_network_source_ranges
            protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
            port        = port # "80-90" # 80, 80,90 and 80-90
            description = ""
          }
        ])
    }
  }
}

module "cvm" {
  source            = "../../../modules/cvm"
  vpc_id            = module.network.vpc_id
  subnet_id         = module.network.subnet_id[0]
  availability_zone = local.availability_zones[0]
  tags              = local.tags
  project_id        = 0

  instance_name = "${local.prefix}-teo-demo"
  instance_type = local.instance_type
  os_name       = local.os_name

  system_disk_size   = local.system_disk_size
  security_group_ids = [module.security_groups.ids["${local.prefix}-teo-demo"]]
  password           = local.cvm_password

  allocate_public_ip = true
  internet_max_bandwidth_out = 100
  user_data_raw      = local.user_data_raw


}

output "all" {
  value = module.cvm.public_ips
}
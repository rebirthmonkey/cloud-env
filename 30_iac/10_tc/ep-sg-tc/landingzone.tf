data "tencentcloud_user_info" "this" {}

locals {
  # owner_uin = data.tencentcloud_user_info.this.owner_uin
  default_sg_id = module.security_group.ids["${local.name}_${local.sg_name}"]
}

/* 后续考虑账号相关的设计
resource "tencentcloud_cam_role" "role" {
  document      = jsonencode(
    {
      "version": "2.0",
      "statement": [
        {
          "action": "name/sts:AssumeRoleWithWebIdentity",
          "effect": "allow",
          "principal": {
            "federated": [
              "qcs::cam::uin/${local.owner_uin}:oidc-provider/${module.tke.cluster_id}"
            ]
          },
          "condition": {
            "string_equal": {
              #          "oidc:iss": [var.tke_default_issuer],
              "oidc:aud": ["sts.cloud.tencent.com"]
            }
          }
        }
      ]
    }
  )

  name          = local.name
  session_duration = 7200
  console_login = false
  description   = ""
  tags          = local.tags
}

resource "tencentcloud_cam_role_policy_attachment_by_name" "role_policy_attachment_basic" {
  depends_on = [tencentcloud_cam_role.role]
  role_name   = local.name
  policy_name = "AdministratorAccess"
}
*/

module "eip" {
  source = "../modules/eip"
  eips = {
    nat = {
      name                      = "${local.name}-nat"
      internet_max_bandwidth_out = 100
      tags                      = local.tags
    }
  }
}

module "network" {
  source             = "../modules/vpc"
  vpc_name           = "${local.name}_vpc"
  vpc_cidr           = local.vpc_cidr
  vpc_is_multicast   = false
  tags               = local.tags
  availability_zones = local.availability_zones
  subnet_name        = "${local.name}_subnet-mo"
  subnet_cidrs       = local.subnet_man_cidrs
  subnet_tags        = local.tags
  enable_nat_gateway = true
  nat_public_ips     = [module.eip.public_ips["nat"]]
  destination_cidrs  = ["0.0.0.0/0"]
  next_type          = ["NAT"]
  next_hub           = ["0"]
}

module "node_network" {
  source             = "terraform-tencentcloud-modules/vpc/tencentcloud"
  version            = "1.1.0"
  create_vpc         = false
  vpc_id             = module.network.vpc_id
  availability_zones = local.availability_zones
  subnet_name        = "${local.name}_subnet-tke-node"
  subnet_cidrs       = local.subnet_tke_node_cidrs
  subnet_tags        = local.tags
}

module "pod_network" {
  source             = "terraform-tencentcloud-modules/vpc/tencentcloud"
  version            = "1.1.0"
  create_vpc         = false
  vpc_id             = module.network.vpc_id
  availability_zones = local.availability_zones
  subnet_name        = "${local.name}_subnet-tke-pod"
  subnet_cidrs       = local.subnet_tke_pod_cidrs
  subnet_tags        = local.tags
}

module "security_group" {
  source = "../modules/security-group"
  security_groups = {
    well-known = {
      name = "${local.name}_${local.sg_name}"
      ingress = concat(
        [
          {
            action      = "ACCEPT"
            cidr_block  = local.vpc_cidr
            protocol    = "TCP"
            port        = "ALL"
            description = "vpc cidr"
          }
        ],
        [
          {
            action      = "ACCEPT"
            cidr_block  = "${module.eip.public_ips["nat"]}/32"
            protocol    = "TCP"
            port        = "ALL"
            description = "vpcgw"
          }
        ],
        [
          for cidr in local.well_known_cidrs : {
            action      = "ACCEPT"
            cidr_block  = cidr
            protocol    = "TCP"
            port        = "ALL"
            description = "office cidr"
          }
        ],
        [
          for port in local.well_known_ports : {
            action      = "ACCEPT"
            cidr_block  = "0.0.0.0/0"
            protocol    = "TCP"
            port        = port
            description = ""
          }
        ]
      )
    }
  }
}

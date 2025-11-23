locals {
  env_name = basename(abspath("./"))
  name = "${local.env_name}"
  region = "ap-singapore"
  availability_zones = ["ap-singapore-3", "ap-singapore-2", "ap-singapore-1"]
  project_id = 0
  # atalntis server镜像存在tcr中，需要先补全
  tcr_token = "" # 由于获取token方法繁琐，已废弃该配置，改为使用kubectl命令创建该secret

  # gitlab和atlantis执行CICD的assume role
  gitlab_role_name   = "role_ep-sg-sts"
  atlantis_role_name = "role_ep-sg-sts"

  vpc_cidr = "10.0.0.0/16"
  subnet_man_cidrs = ["10.0.0.0/24" ,"10.0.1.0/24" ,"10.0.2.0/24"]
  subnet_tke_pod_cidrs = ["10.0.4.0/24" ,"10.0.5.0/24" ,"10.0.6.0/24"]
  subnet_tke_node_cidrs = ["10.0.8.0/24" ,"10.0.9.0/24" ,"10.0.10.0/24"]

  well_known_cidrs = [
    # 公司出口 IP 段，如果用其他地址访问，请先找到出口 IP ，加入到这个列表里; 
    # cell网络：10.1.0.0/16
    # 每个出口进行注释
    "61.135.194.0/24",
    "111.206.145.0/24",
    "59.152.39.0/24",
    "180.78.55.0/24",
    "111.206.94.0/24",
    "111.206.96.0/24",
    "43.132.141.0/24", # shenzhen office
    "14.22.11.0/24", # devnet net: AnyDev云研发
    "14.116.239.0/24", # devnet net: AnyDev云研发
    "203.149.215.0/24", # singapore office
    "203.149.194.0/24", # singapore office
    "10.1.0.0/16", # dev-cell0-gz网络
    "124.156.194.0/24", # ep-sg跳板机公网出口
    "172.16.0.0/12", # AWS侧内网IP
    "52.221.244.190/32", # AWS侧跳板机登录argocd
  ]

  well_known_ports = [
    
  ]

  sg_name = "sg-default-00"

  # cvm
  # Todo: I don't want to submit this password to others.
  instance_password = "P@ssw0rd"
  instance_type = "SA2.MEDIUM2"

  image_type = ["PRIVATE_IMAGE"]
  image_name = "iac_jumper_server"

  os_name = null
  system_disk_size = 50
  internet_max_bandwidth_out = 10

  # domain
  domain_name = "overseasops.com"
  # sub domain
  sub_domain_gitlab = "gitlab-ops-ep-sg"
  sub_domain_gitlab_gitlab = "gitlab.gitlab-ops-ep-sg"
  sub_domain_gitlab_registry = "registry.gitlab-ops-ep-sg"
  sub_domain_argocd = "argocd-ops-ep-sg"
  sub_domain_atlantis = "atlantis-ops-ep-sg"
  sub_domain_consul = "consul-ops-ep-sg"
  sub_domain_grafana = "grafana-ops-ep-sg"

  # ssl tencentcloud_user_info
  # Todo: I don't want to push email and phone number
  ssl_email = "${local.name}@tencent.com"
  ssl_phone = "17688798192"

  # gitlab user
  gitlab_user_name = "gitlab-ops-ep-sg"
  gitlab_user_email = "${local.name}@tencent.com"
  gitlab_user_password = "P@ssw0rd"

  # atlantic user info  gitlab user
  atlantis_username = "atlantis-ops-ep-sg"
  atlantis_password = "P@ssw0rd"

  # grafana password
  grafana_password = "P@ssw0rd"

  # prometheus_cross_account_config
  prometheus_cross_account_policy_name = "policy_prometheus-cross-account"
  prometheus_cross_account_role_name   = "role_prometheus-cross-account"

  tags = {
    created_by: "terraform"
  }
}


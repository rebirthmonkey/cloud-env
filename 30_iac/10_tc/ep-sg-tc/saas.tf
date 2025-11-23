module "clb_gitlab" {
  source = "../modules/clb"
  name          = "${local.name}_clb-gitlab"
  create        = true
  internet_bandwidth_max_out = 100
  internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
  dynamic_vip  = true
  create_listener = false
  create_listener_rules = false

  vpc_id = module.network.vpc_id
  security_groups = [local.default_sg_id]

  tags = local.tags
}

module "clb_atlantis" {
  source = "../modules/clb"
  name          = "${local.name}_clb-atlantis"
  create        = true
  internet_bandwidth_max_out = 100
  internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
  dynamic_vip  = true
  create_listener = false
  create_listener_rules = false

  vpc_id = module.network.vpc_id
  security_groups = [local.default_sg_id]

  tags = local.tags
}

module "clb_argocd" {
  source = "../modules/clb"
  name          = "${local.name}_clb-argocd"
  create        = true
  internet_bandwidth_max_out = 100
  internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
  dynamic_vip  = true
  create_listener = false
  create_listener_rules = false

  vpc_id = module.network.vpc_id
  security_groups = [local.default_sg_id]

  tags = local.tags
}

module "clb_consul" {
  source = "../modules/clb"
  name          = "${local.name}_clb-consul"
  create        = true
  internet_bandwidth_max_out = 100
  internet_charge_type = "TRAFFIC_POSTPAID_BY_HOUR"
  dynamic_vip  = true
  create_listener = false
  create_listener_rules = false

  vpc_id = module.network.vpc_id
  security_groups = [local.default_sg_id]

  tags = local.tags
}

/* Todo: Need fix
# Error: [TencentCloudSDKError] Code=FailedOperation.DomainExists, Message=该域名已在您的列表中，无需重复添加。
module "dnspod_domain" {
  source  = "../modules/dnspod-domain"
  domain = local.domain_name
}
*/

/*
# 域名解析可以配置泛域名
module "dnspod_domain_record_gitlab" {
  # depends_on = [module.dnspod_domain]
  source  = "../modules/dnspod-domain-record"
  domain = local.domain_name
  record_type = "CNAME"
  value = module.clb_gitlab.clb_domain
  sub_domain = "*.${local.sub_domain_gitlab}"
}
*/

module "dnspod_domain_record_gitlab_main" {
  # depends_on = [module.dnspod_domain]
  source  = "../modules/dnspod-domain-record"
  domain = local.domain_name
  record_type = "CNAME"
  value = module.clb_gitlab.clb_domain
  sub_domain = local.sub_domain_gitlab_gitlab
}

module "dnspod_domain_record_gitlab_registry" {
  # depends_on = [module.dnspod_domain]
  source  = "../modules/dnspod-domain-record"
  domain = local.domain_name
  record_type = "CNAME"
  value = module.clb_gitlab.clb_domain
  sub_domain = local.sub_domain_gitlab_registry
}

module "dnspod_domain_record_argocd" {
  # depends_on = [module.dnspod_domain]
  source  = "../modules/dnspod-domain-record"
  domain = local.domain_name
  record_type = "CNAME"
  value = module.clb_argocd.clb_domain
  sub_domain = local.sub_domain_argocd
}

module "dnspod_domain_record_atlantis" {
  # depends_on = [module.dnspod_domain]
  source  = "../modules/dnspod-domain-record"
  domain = local.domain_name
  record_type = "CNAME"
  value = module.clb_atlantis.clb_domain
  sub_domain = local.sub_domain_atlantis
}

module "dnspod_domain_record_consul" {
  # depends_on = [module.dnspod_domain]
  source       = "../modules/dnspod-domain-record"
  domain       = local.domain_name
  record_type  = "CNAME"
  value        = module.clb_consul.clb_domain
  sub_domain   = local.sub_domain_consul
}


/*
# 当前使用免费SSL证书只能绑定一个域名
module "ssl_gitlab" {
  source = "../modules/ssl"
  domain = "${local.sub_domain_gitlab}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias = "${local.sub_domain_gitlab}.${local.domain_name}"
}
*/

module "ssl_gitlab_main" {
  source = "../modules/ssl"
  domain = "${local.sub_domain_gitlab_gitlab}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias = "${local.sub_domain_gitlab_gitlab}.${local.domain_name}"
}

module "ssl_gitlab_registry" {
  source = "../modules/ssl"
  domain = "${local.sub_domain_gitlab_registry}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias = "${local.sub_domain_gitlab_registry}.${local.domain_name}"
}

module "ssl_argocd" {
  source = "../modules/ssl"
  domain = "${local.sub_domain_argocd}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias = "${local.sub_domain_argocd}.${local.domain_name}"
}

module "ssl_atlantis" {
  source = "../modules/ssl"
  domain = "${local.sub_domain_atlantis}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias = "${local.sub_domain_atlantis}.${local.domain_name}"
}

module "ssl_consul" {
  source         = "../modules/ssl"
  domain         = "${local.sub_domain_consul}.${local.domain_name}"
  contact_email  = local.ssl_email
  contact_phone  = local.ssl_phone
  alias          = "${local.sub_domain_consul}.${local.domain_name}"
}


resource "null_resource" "print_localiables" {
  provisioner "local-exec" {
    command = <<-EOT
      echo "GITLAB_MAIN_DOMAIN: "${local.sub_domain_gitlab}.${local.domain_name}"
      echo "GITLAB_MAIN_SSL_ID: module.ssl_gitlab_main.ssl_id[0]
    EOT
  }
}

# 创建Prmetheus和Grafana资源
module "prometheus" {
  source = "../modules/prometheus"

  prometheus_instance_name = "${local.name}-prometheus"
  vpc_id                   = module.network.vpc_id
  subnet_id                = module.node_network.subnet_id[0]
  data_retention_time      = 15
  availability_zone        = local.availability_zones[0]
  prometheus_tags          = local.tags
}
module "grafana" {
  source = "../modules/grafana"

  grafana_instance_name   = "${local.name}-grafana"
  grafana_vpc_id          = module.network.vpc_id
  grafana_subnet_ids      = module.node_network.subnet_id
  grafana_init_password   = local.grafana_password
  enable_internet         = false
  is_destroy              = false
  grafana_tags            = local.tags
  create_grafana_instance = true

  # 与 Prometheus 绑定
  prometheus_instance_id = module.prometheus.prometheus_id
}

# 创建Grafana证书并创建clb，终止证书并监听Grafana内网服务
module "ssl_grafana" {
  source        = "../modules/ssl"
  domain        = "${local.sub_domain_grafana}.${local.domain_name}"
  contact_email = local.ssl_email
  contact_phone = local.ssl_phone
  alias         = "${local.sub_domain_grafana}.${local.domain_name}"
}

locals {
  grafana_hostport = module.grafana.grafana_internal_url
  grafana_ip       = split(":", local.grafana_hostport)[0]
  grafana_port     = tonumber(split(":", local.grafana_hostport)[1])
}

module "clb_grafana" {
  source     = "../modules/clb"
  depends_on = [module.ssl_grafana]

  name            = "${local.name}-clb-grafana"
  network_type    = "OPEN"
  vpc_id          = module.network.vpc_id
  security_groups = [local.default_sg_id]
  dynamic_vip     = true

  # 老的 HTTP/TCP 监听器关闭
  create_listener       = false
  create_listener_rules = false

  # —— 新增：HTTPS 监听器 + 规则 + 绑定后端 ——
  create_tls_listener  = true
  tls_protocol         = "HTTPS"
  tls_listener_name    = "grafana-https-443"
  tls_port             = 443

  # 证书（单向 TLS）
  certificate_id       = module.ssl_grafana.ssl_id[0]
  certificate_ssl_mode = "UNIDIRECTIONAL"
  certificate_ca_id    = null

  # 规则：域名 + 路径
  tls_domain = "${local.sub_domain_grafana}.${local.domain_name}"  # 例：grafana.example.com
  tls_url    = "/"

  # 绑定后端：Grafana 内网 IP:3000
  enable_backend_attach = true
  backends = [
    { ip = local.grafana_ip, port = local.grafana_port, weight = 10 }
  ]

  tags = local.tags
}

# 创建云解析DNS，绑定grafana证书->clb-grafana
module "dnspod_domain_record_grafana" {
  # depends_on = [module.dnspod_domain]
  source       = "../modules/dnspod-domain-record"
  domain       = local.domain_name
  record_type  = "CNAME"
  value        = module.clb_grafana.clb_domain
  sub_domain   = local.sub_domain_grafana
}



# local file render
# Create an account for atlantis in advance
resource "local_file" "atlantis_service_account" {
  content = templatefile("./tftpl/atlantis-service-account.yaml.tftpl", {
    ATLANTIS_ACCOUNT_NAME = "service-account-${local.env_name}"
    ATLANTIS_ROLE_NAME    = local.atlantis_role_name
    OWNER_UIN             = data.tencentcloud_user_info.this.owner_uin
  })
  filename = "./atlantis/atlantis-service-account.yaml"
}

# generate gitlab-values of helm
resource "local_file" "gitlab-values" {
  content = templatefile("./tftpl/gitlab-values.yaml.tftpl", {
    GITLAB_DOMAIN: "${local.sub_domain_gitlab}.${local.domain_name}"
    GITLAB_CLB_ID: module.clb_gitlab.clb_id
    GITLAB_ISSUER_EMAIL: "${local.gitlab_user_email}"
  })
  filename = "./gitlab/gitlab-values.yaml"
}

# generate argocd-values of helm
resource "local_file" "argocd-values" {
  content = templatefile("./tftpl/argocd-values.yaml.tftpl", {
    ARGOCD_DOMAIN: "${local.sub_domain_argocd}.${local.domain_name}"
    ARGOCD_CLB_ID: module.clb_argocd.clb_id
  })
  filename = "./argocd/argocd-values.yaml"
}

resource "local_file" "argocd-secret" {
  content = templatefile("./tftpl/argocd-secret.yaml.tftpl", {
    ARGOCD_SSL_ID: base64encode(module.ssl_argocd.ssl_id[0])
  })
  filename = "./argocd/argocd-secret.yaml"
}

# generate atlantis-values of helm
resource "local_file" "atlantis-values" {
  content = templatefile("./tftpl/atlantis-values.yaml.tftpl", {
    GITLAB_DOMAIN: "gitlab.${local.sub_domain_gitlab}.${local.domain_name}"
    ATLANTIS_CLB_ID: module.clb_atlantis.clb_id
    ATLANTIS_USERNAME: "${local.atlantis_username}"
    ATLANTIS_PASSWORD: "${local.atlantis_password}"
  })
  filename = "./atlantis/atlantis-values.yaml"
}

resource "local_file" "atlantis-secret" {
  content = templatefile("./tftpl/atlantis-secret.yaml.tftpl", {
    ATLANTIS_SSL_ID: base64encode(module.ssl_atlantis.ssl_id[0])
  })
  filename = "./atlantis/atlantis-secret.yaml"
}

resource "local_file" "atlantis-pvc" {
  content = templatefile("./tftpl/atlantis-pvc.yaml.tftpl", {
  })
  filename = "./atlantis/atlantis-pvc.yaml"
}

resource "local_file" "atlantis-provider-job" {
  content = templatefile("./tftpl/atlantis-provider-init-job.yaml.tftpl", {
  })
  filename = "./atlantis/atlantis-provider-init-job.yaml"
}

resource "local_file" "gitlab_service_account" {
  content = templatefile("./tftpl/gitlab-service-account.yaml.tftpl", {
    GITLAB_ACCOUNT_NAME = "gitlab-runner-oidc"
    GITLAB_ROLE_NAME    = local.gitlab_role_name
    OWNER_UIN           = data.tencentcloud_user_info.this.owner_uin
  })
  filename = "./gitlab/gitlab-service-account.yaml"
}

resource "local_file" "consul-values" {
  content = templatefile("./tftpl/consul-values.yaml.tftpl", {
    CONSUL_CLB_ID = module.clb_consul.clb_id
  })
  filename = "./consul/consul-values.yaml"
}

resource "local_file" "consul-secret" {
  content = templatefile("./tftpl/consul-secret.yaml.tftpl", {
    CONSUL_SSL_ID = base64encode(module.ssl_consul.ssl_id[0])
  })
  filename = "./consul/consul-secret.yaml"
}

resource "local_file" "gitlab_dashboard_crt" {
  content  = module.ssl_gitlab_main.certificate_public_key
  filename = "${path.module}/gitlab/gitlab-dashboard.crt"
}

resource "local_file" "gitlab_dashboard_key" {
  content  = module.ssl_gitlab_main.certificate_private_key
  filename = "${path.module}/gitlab/gitlab-dashboard.key"
  file_permission = "0600"
}

resource "local_file" "gitlab_registry_crt" {
  content  = module.ssl_gitlab_registry.certificate_public_key
  filename = "${path.module}/gitlab/gitlab-registry.crt"
}

resource "local_file" "gitlab_registry_key" {
  content  = module.ssl_gitlab_registry.certificate_private_key
  filename = "${path.module}/gitlab/gitlab-registry.key"
  file_permission = "0600"
}

# 创建Policy(服务于Prometheus跨账号监控)
module "cam_policy" {
  source = "../modules/cam-policy"

  cross_policy_name = local.prometheus_cross_account_policy_name

  # 调试期可留空；正式建议填目标 ARN（示例）：
  assume_role_resources = [
    # "qcs::cam::uin/1000xxxxxxxx:roleName/${local.prometheus_cross_account_role_name}"
  ]
}

# 账号 A：创建角色，并把上面的策略绑定到该角色
module "cam_role" {
  source = "../modules/cam-role"

  cross_role_name = local.prometheus_cross_account_role_name
  carrier_service = "cvm.qcloud.com"

  # 绑定刚创建的策略
  attach_policy_names = [
    module.cam_policy.policy_name
  ]
}

/*
# 待泛域名方案确认
resource "local_file" "update_gitlab_helm_post" {
  content = templatefile("./tftpl/gitlab-helm-post.sh.tftpl", {
    GITLAB_DOMAIN: "${local.sub_domain_gitlab}.${local.domain_name}"
    GITLAB_SSL_ID: module.ssl_gitlab.ssl_id[0]
  })
  filename = "./gitlab/gitlab-helm-post.sh"
}

resource "local_file" "update_gitlab_helm_post" {
  content = templatefile("./tftpl/gitlab-helm-post.sh.tftpl", {
    GITLAB_MAIN_DOMAIN: "${local.sub_domain_gitlab_gitlab}.${local.domain_name}"
    GITLAB_MAIN_SSL_ID: module.ssl_gitlab_main.ssl_id[0]
    GITLAB_REGISTRY_DOMAIN: "${local.sub_domain_gitlab_registry}.${local.domain_name}"
    GITLAB_REGISTRY_SSL_ID: module.ssl_gitlab_registry.ssl_id[0]
  })
  filename = "./gitlab/gitlab-helm-post.sh"
}


*/


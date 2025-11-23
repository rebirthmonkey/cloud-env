# TencentCloud CLB Module for Terraform

## terraform-tencentcloud-clb

A terraform module used to create TencentCloud CLB instance.

The following resources are included.

* [CLB](https://www.terraform.io/docs/providers/tencentcloud/r/clb_instance.html)
* [CLB Listener](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_listener)
* [CLB Listener Rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_listener_rule)
* [CLB_Redirection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_redirection)
* [CLB Log Set](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_log_set)
* [CLB Log Topic](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_log_topic)

## Usage

There are some ways to create clb using this module:

1. [Specifying listeners (HTTP, HTTPS, TCP, TCP_SSL, etc.)](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-clb#CLB-Module-With-Listeners)
2. [Specifying Listeners Redirection](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-clb#CLB-Module-Listeners-Redirection)
3. [Specifying Log](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-clb#CLB-Instance-With-Log)

### CLB Module With Listeners

```hcl
module "clb-instance-with-listeners" {
  source = "terraform-tencentcloud-modules/clb/tencentcloud"

  network_type    = "OPEN"
  clb_name        = "tf-clb-module-with-listener"
  vpc_id          = "your_vpc_id"
  project_id      = 0
  security_groups = ["your_security_group_id"]

  clb_listeners = [
    {
      listener_name       = "tcp_listener"
      protocol            = "TCP"
      port                = 66
      session_expire_time = 30
    },
    {
      listener_name = "http_listener"
      protocol      = "HTTP"
      port          = 80
    },
    {
      listener_name        = "https_listener"
      protocol             = "HTTPS"
      port                 = 443
      certificate_ssl_mode = "UNIDIRECTIONAL"
      certificate_id       = "your_certificate_id"
    },
    {
      listener_name        = "tcp_ssl_listener"
      protocol             = "TCP_SSL"
      port                 = 67
      certificate_ssl_mode = "UNIDIRECTIONAL"
      certificate_id       = "your_certificate_id"
    }
  ]

  clb_tags = {
    test = "tf-clb-module"
  }
}

```

### CLB Module Listener Redirection

```hcl
module "clb-instance-listener-redirection" {
  source = "terraform-tencentcloud-modules/clb/tencentcloud"

  network_type            = "OPEN"
  clb_name                = "tf-clb-module-listener-redirection"
  vpc_id                  = "your_vpc_id"
  project_id              = 0
  security_groups         = ["your_security_group_id"]
  create_listener_rules   = true
  create_clb_redirections = true

  clb_listeners = [
    {
      listener_name = "http_listener1"
      protocol      = "HTTP"
      port          = 80
    },
    {
      listener_name = "http_listener2"
      protocol      = "HTTP"
      port          = 88
    }
  ]

  clb_tags = {
    test = "tf-clb-module"
  }

  clb_listener_rules = [
    {
      listener_index = 0
      domain         = "foo.net"
      url            = "/index"
    },
    {
      listener_index = 0
      domain         = "foo.net"
      url            = "/index1"
    },
    {
      listener_index = 1
      domain         = "foo.net"
      url            = "/index"
    }
  ]

  clb_redirections = [
    {
      source_listener_rule_index = 0
      target_listener_rule_index = 2
    }
  ]
}

```

### CLB Instance With Log

```hcl
module "clb-instance-with-log" {
  source = "terraform-tencentcloud-modules/clb/tencentcloud"

  network_type       = "OPEN"
  clb_name           = "tf-clb-module-with-log"
  vpc_id             = "your_vpc_id"
  project_id         = 0
  security_groups    = ["your_security_group_id"]
  create_clb_log     = true
  clb_log_set_period = 7
  clb_log_topic_name = "clb_topic"

  clb_listeners = [
    {
      listener_name       = "tcp_listener"
      protocol            = "TCP"
      port                = 66
      session_expire_time = 30
    }
  ]

  clb_tags = {
    test = "tf-clb-module"
  }
}

```

## Conditional Creation

The following values are provided to toggle on/off creation of the associated resources as desired:

```hcl
module "clb" {
  source = "terraform-tencentcloud-modules/clb/tencentcloud"

  # Enable creation of listeners
  create_listener = true
  
  # Enable creation of listener rules
  create_listener_rules = true
  
  # Enable creation of redirections
  create_clb_redirections = true

  # Enable creation of clb_log_set & clb_log_topic
  create_clb_log = true

  # ... omitted
}
```


## Inputs

| Name                         | Description                                                  |     Type     |    Default     | Required |
| ---------------------------- | ------------------------------------------------------------ | :----------: | :------------: | :------: |
| project_id                   | Id of the project within the CLB instance, '0' - Default Project. |    number    |      null      |    no    |
| clb_name                     | Name of the CLB. The name can only contain Chinese characters, English letters, numbers, underscore and hyphen '-'. |    string    | tf-modules-clb |    no    |
| clb_tags                     | The available tags within this CLB.                          | map(string)  |       {}       |    no    |
| network_type                 | Type of CLB instance, and available values include 'OPEN' and 'INTERNAL'. |    string    |      null      |    no    |
| vpc_id                       | VPC id of the CLB.                                           |    string    |      null      |    no    |
| subnet_id                    | Subnet id of the CLB. Effective only for CLB within the VPC. Only supports 'INTERNAL' CLBs. |    string    |      null      |    no    |
| security_groups              | Security groups of the CLB instance. Only supports 'OPEN' CLBs. | list(string) |      null      |    no    |
| create_clb_log               | Whether to create clb log.  Priority is lower than log_set_id and log_topic_id. |     bool     |      false      |   no    |
| clb_log_set_period           | Logset retention period in days. Maximun value is 90.        |    number    |       7        |    no    |
| clb_log_topic_name           | Log topic of CLB instance.                       |    string    |  "clb-topic"   |    no    |
| log_set_id                   | The id of log set.                               |    string    |  "" | no
| log_topic_id                 | The id of log topic.                             |    string    |  "" | no   |
| address_ip_version           | IP version, only applicable to open CLB. Valid values are ipv4, ipv6 and IPv6FullChain. |  string |  null  | no |
| bandwidth_package_id         | Bandwidth package id. If set, the internet_charge_type must be BANDWIDTH_PACKAGE. |  string  |  null |  no  |
| internet_bandwidth_max_out   | Max bandwidth out, only applicable to open CLB. Valid value ranges is [1, 2048]. Unit is MB. |  number  |  null  |  no  |
| internet_charge_type         | Internet charge type, only applicable to open CLB. Valid values are TRAFFIC_POSTPAID_BY_HOUR, BANDWIDTH_POSTPAID_BY_HOUR and BANDWIDTH_PACKAGE. |  string  |  null  |  no  |
| load_balancer_pass_to_target | Whether the target allow flow come from clb. If value is true, only check security group of clb, or check both clb and backend instance security group. |     bool     |      null      |   Yes    |
| master_zone_id               | Setting master zone id of cross available zone disaster recovery, only applicable to open CLB. |  string  |  null  |  no  |
| slave_zone_id                | Setting slave zone id of cross available zone disaster recovery, only applicable to open CLB. this zone will undertake traffic when the master is down. |  string  |  null  |  no  |
| snat_ips                     | Snat Ip List, required with snat_pro=true. NOTE: This argument cannot be read and modified here because dynamic ip is untraceable, please import resource tencentcloud_clb_snat_ip to handle fixed ips. |  list(map(string))  |  []  |  no  |
| snat_pro                     | Indicates whether Binding IPs of other VPCs feature switch.  |  bool  |  null  |  no  |
| tags                         | The available tags within this CLB.  |  map(any)  |  null  |  no  |
| target_region_info_region    | Region information of backend services are attached the CLB instance. Only supports OPEN CLBs. |    string    |       ""       |    no    |
| target_region_info_vpc_id    | Vpc information of backend services are attached the CLB instance. Only supports OPEN CLBs.  |  string  |  null  |  no  |
| zone_id                      | Available zone id, only applicable to open CLB.  |  string  |  null  |  no  |
| create_listener              | Whether to create a CLB Listeners. | bool |  true  |  no  |
| clb_listeners                | The CLB Listener config list. Valid values reference [clb_listener](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_listener#argument-reference). | list(map(string)) |       []       |    no    |
| create_listener_rules        | Whether to create a CLB Listener rules. |  bool  |   false   |  no  |
| clb_listener_rules           | The CLB listener rule config list. The index of the clb_listeners parameter is matched by the listener_index. For other valid values reference [clb_listener_rule](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_listener_rule#argument-reference) |  list(map(string))  |  []  |  no  |
| create_clb_redirections      | Whether to create a CLB Listener rules redirection.  |  bool  |  false  |  no  |
| clb_redirections             | The CLB redirection config list. Use source_listener_rule_index/target_listener_rule_index to get source_listener_id/target_listener_id in clb_listener_rules，For other valid values reference [clb_redirection](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/clb_redirection#argument-reference) |  list(map(string))  |  []  |  no  |

## Outputs

| Name             | Description                                   |
| ---------------- | --------------------------------------------- |
| clb_id           | Id of CLB.                                    |
| clb_name         | Name of CLB.                                  |
| status           | The status of CLB.                            |
| status_time      | Latest state transition time of CLB.          |
| create_time      | Creation time of the CLB.                     |
| network_type     | Types of CLB.                                 |
| vip_isp          | Network operator, only applicable to open CLB.|
| clb_vips         | The virtual service address table of the CLB. |
| vpc_id           | Id of the VPC.                                |
| subnet_id        | Id of the subnet.                             |
| security_groups  | Id set of the security groups.                |
| tags             | The available tags within this CLB.           |
| clb_listener_id  | ID of the CLB_listener.                       |
| clb_log_set_id   | The id of log set.                            |
| clb_log_topic_id | The id of log topic.                          |
| clb_listener_rule_id | ID of the listener rule.                  |
| clb_redirection_id   | ID of the clb redirection.                |         


## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
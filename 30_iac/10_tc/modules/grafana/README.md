# terraform-tencentcloud-grafana
Terraform module which creates Grafana resources on TencentCloud

## Usage

```hcl
module "grafana_instance" {
  source = "terraform-tencentcloud-modules/prometheus/tencentcloud//modules/grafana"

  grafana_instance_name = "grafana_for_test"
  grafana_vpc_id        = ["vpc-xxxxx"]
  grafana_subnet_ids    = ["subnet-xxxxx"]
  grafana_init_password = "xxxxxx"
  enable_internet       = true
  is_destroy            = false

  grafana_tags = {
    "createby" = "terraform"
  }
  prometheus_instance_id = "prom-xxxxx"
}
```

## Examples

- [Simple](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/simple)
- [Exist Prometheus](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/exist-prometheus)
- [Complete](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-prometheus/tree/master/examples/complete)


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.12 |
| <a name="requirement_tencentcloud"></a> [tencentcloud](#requirement\_tencentcloud) | >=1.81.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tencentcloud"></a> [tencentcloud](#provider\_tencentcloud) | >=1.81.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tencentcloud_monitor_grafana_instance.grafana_instance](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/monitor_grafana_instance) | resource |
| [tencentcloud_monitor_tmp_manage_grafana_attachment.attachment](https://registry.terraform.io/providers/tencentcloudstack/tencentcloud/latest/docs/resources/monitor_tmp_manage_grafana_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_grafana_instance"></a> [create\_grafana\_instance](#input\_create\_grafana\_instance) | Controls if Grafana instance should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_enable_internet"></a> [enable\_internet](#input\_enable\_internet) | Control whether grafana could be accessed by internet. | `bool` | `false` | no |
| <a name="input_grafana_init_password"></a> [grafana\_init\_password](#input\_grafana\_init\_password) | Grafana server admin password. | `string` | `null` | no |
| <a name="input_grafana_instance_id"></a> [grafana\_instance\_id](#input\_grafana\_instance\_id) | ID of Grafana instance. | `string` | `null` | no |
| <a name="input_grafana_instance_name"></a> [grafana\_instance\_name](#input\_grafana\_instance\_name) | Name of Grafana instance to be created. | `string` | `null` | no |
| <a name="input_grafana_subnet_ids"></a> [grafana\_subnet\_ids](#input\_grafana\_subnet\_ids) | Subnet Id of Grafana instance. | `set(string)` | `null` | no |
| <a name="input_grafana_tags"></a> [grafana\_tags](#input\_grafana\_tags) | Tags of the Grafana instance to be created. | `map(string)` | `{}` | no |
| <a name="input_grafana_vpc_id"></a> [grafana\_vpc\_id](#input\_grafana\_vpc\_id) | Vpc Id of Grafana instance. | `string` | `null` | no |
| <a name="input_is_destroy"></a> [is\_destroy](#input\_is\_destroy) | Whether to clean up completely, the default is false. | `bool` | `false` | no |
| <a name="input_prometheus_instance_id"></a> [prometheus\_instance\_id](#input\_prometheus\_instance\_id) | ID of Grafana instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_id"></a> [grafana\_id](#output\_grafana\_id) | The Id of Grafana Instance. |
<!-- END_TF_DOCS -->

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
